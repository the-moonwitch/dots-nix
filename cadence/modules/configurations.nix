{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (config) cadence;
  inherit (cadence.lib) const;
  inherit (builtins)
    attrNames
    attrValues
    concatStringsSep
    filter
    foldl'
    genericClosure
    groupBy
    getAttr
    hasAttr
    listToAttrs
    map
    mapAttrs
    ;
  hostLabels = attrNames cadence.hosts;
  hostDefs = map (label: cadence.hosts.${label} // { inherit label; }) hostLabels;
  allFeatures = attrNames (cadence.dependencies // cadence.features);
  resolveDeps =
    deps:
    let
      validate =
        featureName:
        assert
          lib.elem featureName allFeatures
          || throw ''
            Undefined feature `${featureName}`.
            Known features: [ ${concatStringsSep ", " allFeatures} ];
          '';
        {
          key = featureName;
        };
      resolvedTagsAndFeatures = genericClosure {
        startSet = map validate deps;
        operator = { key }: map validate (cadence.dependencies.${key} or [ ]);
      };
      resolvedFeatures = filter ({ key }: hasAttr key cadence.features) resolvedTagsAndFeatures;
      featureDefs = map (
        { key }:
        {
          name = key;
          value = cadence.features.${key};
        }
      ) resolvedFeatures;
    in
    featureDefs;

  # string -> attrsOf ( attrsOf module )
  hostModules =
    hostDef:
    let
      class = hostDef.class;
      systemClass = if class == const.class.homeManager then null else class;
      hostFeatures = (
        hostDef.features
        ++ (lib.optional (lib.elem "base" allFeatures) "base")
        ++ (lib.optional (lib.elem hostDef.label allFeatures) hostDef.label)
      );
      # canonicalModule :: { name :: string, value :: module}
      # canonicalModuleWithClass :: { class :: string, value :: canonicalModule }
      # featureAsModules :: { name :: string, value :: attrsOf featureImpl } -> [ canonicalModuleWithClass ]
      featureAsModules =
        { name, value }:
        let
          featureLabel = name; # :: string
          featureImpls = value; # :: attrsOf featureImpl
          canonicalModule = implName: mod: {
            name = "cadence-${hostDef.label}-${featureLabel}-${implName}";
            value = mod;
          };
          # string -> featureImpl -> [ canonicalModuleWithClass ]
          implAsModules =
            implName:
            {
              pred,
              ...
            }@i:
            if pred hostDef then
              (lib.optional (i.${const.class.homeManager} != { }) {
                class = const.class.homeManager;
                value = canonicalModule implName i.${const.class.homeManager};
              })
              ++ lib.optional (systemClass != null) {
                class = systemClass;
                value = canonicalModule implName i.${systemClass};
              }
            else
              [ ];
          # [ [ canonicalModuleWithClass ] ]
          impls = lib.mapAttrsToList implAsModules featureImpls;
        in
        # [ canonicalModuleWithClass ]
        lib.flatten impls;
    in
    lib.pipe hostFeatures [
      # [ { name :: string, value :: module } ]
      resolveDeps
      # [ [ canonicalModuleWithClass ] ]
      (map featureAsModules)
      # [ canonicalModuleWithClass ]
      lib.flatten
      # attrsOf [ canonicalModuleWithClass ]
      (groupBy (mod: mod.class))
      # attrsOf ( attrsOf module )
      (mapAttrs (
        _: cModules:
        let
          # [ {name :: string, value :: string} ]
          modules = map (mod: mod.value) cModules;
        in
        # attrsOf ( attrsOf module )
        listToAttrs modules
      ))
    ];

  # attrsOf (attrsOf ( attrsOf module ))
  #
  # modulesByHost.<hostlabel>.<class>.<name> :: module
  modulesByHost = builtins.foldl' (
    acc: hostDef:
    acc
    // {
      ${hostDef.label} = hostModules hostDef;
    }
  ) { } hostDefs;

  modulesByClass = foldl' (acc: modules: lib.recursiveUpdate acc modules) { } (
    attrValues modulesByHost
  );

  # configs
  configurations =
    let
      hosts = lib.mapAttrsToList (label: hostDef: {
        def = hostDef // {
          inherit label;
        };
        modules = (
          mapAttrs (
            class: modules: map (modLabel: inputs.self.modules.${class}.${modLabel}) (attrNames modules)
          ) modulesByHost.${label}
        );
      }) cadence.hosts;
    in
    {
      getKey, # host -> string
      class, # string
      getExtraArgs, # host -> attrset,
      mkSystem,
      getBaseModules, # listOf module
    }:
    builtins.foldl' lib.recursiveUpdate { } (
      map (
        { def, modules }:
        lib.optionalAttrs (def.class == class) {
          ${getKey def} = mkSystem (
            {
              modules = (getBaseModules def) ++ [
                {
                  imports = modules.${class};
                  home-manager.users.${def.username} = {
                    imports = modules.${const.class.homeManager};
                  };
                }
              ];
            }
            // (getExtraArgs def)
          );
        }
      ) hosts
    );

  nixosConfigurations = configurations {
    getKey = getAttr "hostname";
    class = const.class.nixos;
    getExtraArgs = def: {
      system = def.system;
      specialArgs.host = def;
    };
    mkSystem = inputs.nixpkgs.lib.nixosSystem;
    getBaseModules = def: [
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.hostPlatform = def.system;
        networking.hostName = def.hostname;
      }
    ];
  };

  darwinConfigurations = configurations {
    getKey = getAttr "hostname";
    class = const.class.darwin;
    getExtraArgs = def: {
      specialArgs.host = def;
    };
    mkSystem = inputs.nixpkgs.lib.darwinSystem;
    getBaseModules = def: [
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.hostPlatform = def.system;
      }
    ];
  };

  homeConfigurations = configurations {
    getKey = def: "${def.username}@${def.hostname}";
    class = const.class.homeManager;
    getExtraArgs = def: {
      extraSpecialArgs.host = def;
    };
    mkSystem = inputs.home-manager.lib.homeManagerConfiguration;
    getBaseModules = def: [
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.hostPlatform = def.system;
      }
    ];
  };
in
{
  cadence._hostModules = modulesByHost;
  flake.modules = modulesByClass;
  flake.nixosConfigurations = nixosConfigurations;
  flake.darwinConfigurations = darwinConfigurations;
  flake.homeConfigurations = homeConfigurations;
}
