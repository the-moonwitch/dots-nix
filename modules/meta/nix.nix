{ inputs, ... }:
let
  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
in
{
  flake-file = {
    description = "Ninix";
    inherit nixConfig;
    inputs = {
      nix-index-database.url = "github:nix-community/nix-index-database";
    };
  };

  flake.modules = inputs.self.lib.mkFeature "nix" {

    darwin =
      { ... }:
      {
        # nixpkgs.overlays = [ (_final: prev: { nix = prev.lix; }) ];
        # nix.package = pkgs.lix;
        nix.settings = nixConfig // {
          trusted-users = [
            "root"
            "@wheel"
            inputs.self.const.me.username
          ];
        };
      };

    nixos =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [ (_final: prev: { nix = prev.lix; }) ];
        nix.package = pkgs.lix;
        programs.command-not-found.enable = true;
        nix.settings = nixConfig // {
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
      };

    home = {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      programs.nix-index.enable = true;
      programs.nix-index.enableFishIntegration = true;
      programs.nix-index-database.comma.enable = true;

      programs.nh = {
        enable = true;
        flake = ./../../flake.nix;
      };
    };
  };
}
