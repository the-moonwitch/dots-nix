{
  self,
  ...
}:
let
  inherit (builtins) mapAttrs;
  const = import ./_const.nix;
in
{
  flake.lib =
    let
      hostParams = label: self.hosts.${label} // { inherit label; };

      if_ =
        pred: modules:
        mapAttrs (
          _: features:
          mapAttrs (
            _: feature: featureInputs:
            if pred featureInputs.hostParams then feature else { }
          ) features
        );

      featureIf = pred: mapAttrs (name: fn: if_ pred fn);

      featureIfHost = label: featureIf (hostDef: hostDef.label == label);

      feature =
        let
          mkFeature =
            name:
            {
              nixos ? { },
              darwin ? { },
              homeManager ? { },
            }:
            {
              ${const.class.nixos}.${name} = nixos;
              ${const.class.homeManager}.${name} = homeManager;
              ${const.class.darwin}.${name} = darwin;
            };
        in
        {
          nixos = name: nixos: mkFeature name { inherit nixos; };
          darwin = name: darwin: mkFeature name { inherit darwin; };
          homeManager = name: homeManager: mkFeature name { inherit homeManager; };
          system =
            name: mod:
            mkFeature name {
              nixos = mod;
              darwin = mod;
            };
          __functor = mkFeature;
        };
    in
    {
      inherit
        hostParams
        if_
        featureIf
        featureIfHost
        feature
        ;
    };

}
