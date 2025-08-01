{
  /**
    Return a module that, when imported, adds the given names to the list of unfree packages.

    Type:
      declareUnfree : [ String ] -> { lib, ... } -> { nixpkgs.config.allowUnfreePredicate : pkg -> Bool }
  */
  flake.lib.declareUnfree =
    names:
    { lib, ... }:
    {
      nixpkgs.config.allowUnfreePredicate = pkg: lib.elem (lib.getName pkg) names;
    };
}
