{ lib, ... }:
{
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
  };

  flake.aspects."system/home-manager" = {
    homeManager = { pkgs, ... }: {
      home.activation.reindexSpotlight = lib.mkIf pkgs.stdenv.isDarwin (
        lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/echo "Reindexing Spotlight for Home Manager Apps..."
          $DRY_RUN_CMD /usr/bin/mdimport "$HOME/Applications/Home Manager Apps/" 2>/dev/null || true
        ''
      );
    };
  };
}
