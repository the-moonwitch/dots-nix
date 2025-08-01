{ ... }:
{
  /**
    Return platform checks based on nixpkgs.
  */
  flake.lib.platformChecks = pkgs: {
    /**
      Return the first argument on darwin platforms and the second otherwise.
    */
    flake.lib.darwinOr =
      ifDarwin: default: if pkgs.stdenvNoCC.isDarwin then ifDarwin else default;
  };
}
