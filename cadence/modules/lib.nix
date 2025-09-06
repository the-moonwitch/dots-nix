inputs:
let
  inherit (inputs.nixpkgs-lib) lib;
  const = import ./_const.nix;

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
          ${if nixos == { } then null else const.class.nixos}.${name} = nixos;
          ${if homeManager == { } then null else const.class.homeManager}.${name} =
            homeManager;
          ${if darwin == { } then null else const.class.darwin}.${name} = darwin;
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
  inherit feature features const;
}
