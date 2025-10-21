{
  inputs,
  lib,
  config,
  self,
  ...
}:
let
  inherit (inputs.cadence.lib) const;
  inherit (builtins)
    attrNames
    attrValues
    concatLists
    concatMap
    concatStringsSep
    elem
    filter
    foldl'
    genericClosure
    getAttr
    map
    ;
  cfg = config.cadence;
  # TODO: Feature trees group/feature
  featureNames =
    attrNames cfg.dependencies ++ concatMap attrNames (attrValues self.modules);

  resolveDeps =
    deps:
    let
      validate =
        key:
        assert
          lib.elem key featureNames
          || throw ''
            Undefined feature `${key}`.
            Known features: [ ${concatStringsSep ", " featureNames} ]
          '';
        {
          inherit key;
        };
      resolvedFeatures = lib.pipe deps [
        (map validate)
        (
          keys:
          genericClosure {
            startSet = keys;
            operator = { key }: map validate (cfg.dependencies.${key} or [ ]);
          }
        )
        (filter ({ key }: elem key featureNames))
        (map (getAttr "key"))
        lib.unique
      ];
    in
    resolvedFeatures;

  hostConfig =
    hostDef:
    let
      class = hostDef.class;
      systemClass = if class == const.class.homeManager then null else class;
      baseFeatures = lib.unique (concatLists [
        hostDef.features
        (lib.optional (elem "base" featureNames) "base")
        (lib.optional (elem hostDef.label featureNames) hostDef.label)
      ]);
      resolvedFeatures = resolveDeps baseFeatures;
      resolvedModules =
        moduleType:
        builtins.filter (f: f != null) (
          builtins.map (
            f: inputs.self.modules.${moduleType}.${f} or null
          ) resolvedFeatures
        );
      homeDir =
        if hostDef.class == "darwin" then
          "/Users/${hostDef.username}"
        else
          "/home/${hostDef.username}";
      homeModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${hostDef.username} = {
          _module.args = {
            host = hostDef;
            home = homeDir;
          };
          imports = resolvedModules "homeManager";
        };
      };

      systemConfig = {
        nixos = inputs.nixpkgs.lib.nixosSystem {
          inherit (hostDef) system;
          specialArgs = {
            host = hostDef;
            home = homeDir;
          };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            homeModule
            {
              nixpkgs.hostPlatform = hostDef.system;
              networking.hostName = hostDef.hostname;
            }
          ]
          ++ resolvedModules "nixos";
        };
        darwin = inputs.nix-darwin.lib.darwinSystem {
          inherit (hostDef) system;
          specialArgs = {
            host = hostDef;
            home = homeDir;
          };
          modules = [
            inputs.home-manager.darwinModules.home-manager
            homeModule
            { nixpkgs.hostPlatform = hostDef.system; }
          ]
          ++ resolvedModules "darwin";
        };
      };
    in
    {
      ${
        lib.mapNullable (sc: "${sc}Configurations") systemClass
      }.${hostDef.hostname} =
        systemConfig.${systemClass};
      homeConfigurations."${hostDef.username}@${hostDef.hostname}" =
        inputs.home-manager.lib.homeManagerConfiguration
          {
            pkgs = inputs.nixpkgs.legacyPackages.${hostDef.system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }
            ]
            ++ resolvedModules "homeManager";
            extraSpecialArgs = {
              host = hostDef;
              home = homeDir;
            };
          };
    };

  configurations = lib.pipe config.cadence.hosts [
    attrNames
    (map (label: config.cadence.hosts.${label} // { inherit label; }))
    (map hostConfig)
    (foldl' lib.recursiveUpdate {
      nixosConfigurations = { };
      darwinConfigurations = { };
      homeConfigurations = { };
    })
  ];

in
{
  flake.nixosConfigurations = configurations.nixosConfigurations;
  flake.darwinConfigurations = configurations.darwinConfigurations;
  flake.homeConfigurations = configurations.homeConfigurations;
}
