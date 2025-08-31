{
  inputs,
  lib,
  config,
  self,
  ...
}:
let
  inherit (config) cadence;
  inherit (cadence.lib) const;
  inherit (builtins)
    any
    attrNames
    attrValues
    concatLists
    concatStringsSep
    filter
    foldl'
    genericClosure
    getAttr
    map
    ;
  featureNames = attrNames cadence.dependencies ++ lib.flatten (attrValues self.modules);
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
            operator = { key }: map validate (cadence.dependencies.${key} or [ ]);
          }
        )
        (filter ({ key }: any (el: el == key)))
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
        (lib.optional (lib.elem "base" featureNames) "base")
        (lib.optional (lib.elem hostDef.label featureNames) hostDef.label)
      ]);
      resolvedFeatures = resolveDeps baseFeatures;
      resolvedModules =
        moduleType:
        builtins.filter (f: f != null) (
          builtins.map (f: inputs.self.modules.${moduleType}.${f} or null) resolvedFeatures
        );
      homeModule = {
        home-manager.users.${hostDef.username} = {
          imports = resolvedModules "homeManager";
        };
      };

      systemConfig = {
        nixos = inputs.nixpkgs.lib.nixosSystem {
          inherit (hostDef) system;
          specialArgs.host = hostDef;
          modules = [
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
          specialArgs.host = hostDef;
          modules = [
            homeModule
            {
              nixpkgs.hostPlatform = hostDef.system;
            }
          ]
          ++ resolvedModules "darwin";
        };
      };
    in
    {
      ${lib.mapNullable (sc: "${sc}Configurations") systemClass}.${hostDef.hostname} =
        systemConfig.${systemClass};
      homeManagerConfigurations."${hostDef.username}@${hostDef.hostname}" =
        inputs.home-manager.lib.homeManagerConfiguration
          {
            inherit (hostDef) system;
            modules = [
              homeModule
              {
                nixpkgs.hostPlatform = hostDef.system;
              }
            ];
            extraSpecialArgs = {
              host = hostDef;
            };
          };
    };

  configurations = lib.pipe config.cadence.hosts [
    attrNames
    (map inputs.cadence.lib.hostParams)
    (map hostConfig)
    (foldl' lib.recursiveUpdate {
      nixosConfigurations = { };
      darwinConfigurations = { };
      homeManagerConfigurations = { };
    })
  ];

in
{
  flake.nixosConfigurations = configurations.nixosConfigurations;
  flake.darwinConfigurations = configurations.darwinConfigurations;
  flake.homeConfigurations = configurations.homeConfigurations;
}
