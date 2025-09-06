inputs:
let
  inherit (builtins) mapAttrs;
  inherit (inputs.nixpkgs-lib) lib;
  const = import ./_const.nix;
  hostParams = label: inputs.config.flake.hosts.${label} // { inherit label; };

  if_ =
    pred: modules:
    mapAttrs (
      _: features:
      mapAttrs (
        _: f: featureInputs:
        if pred featureInputs.hostParams then f else { }
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
      __functor = _: mkFeature;
    };

  features =
    featList:
    builtins.foldl' (acc: f: lib.recursiveUpdate acc f) {
      nixos = { };
      darwin = { };
      homeManager = { };
    } featList;
in
{
  inherit
    hostParams
    if_
    feature
    featureIf
    featureIfHost
    features
    const
    ;
}
