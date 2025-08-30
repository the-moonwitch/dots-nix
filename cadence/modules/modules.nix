{
  lib,
  config,
  ...
}:
let
  inherit (config) cadence;
  inherit (builtins)
    attrNames
    attrValues
    concatStringsSep
    filter
    genericClosure
    groupBy
    hasAttr
    listToAttrs
    map
    mapAttrs
    zipAttrsWith
    ;
  inherit (cadence.lib) const;
  trace = f: builtins.trace f f;
  hostLabels = trace (attrNames cadence.hosts);
  hostDefs = map (label: (trace cadence.hosts.${label}) // { inherit label; }) (trace hostLabels);
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
            name = "cadence.${hostDef.label}.${featureLabel}.${implName}";
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
  modulesByHost = mapAttrs hostModules (trace hostDefs);
  modulesByClass = zipAttrsWith (class: modules: modules) (attrValues modulesByHost);
in
{
  flake.modules = modulesByClass;
  cadence._hostModules = modulesByHost;
}
