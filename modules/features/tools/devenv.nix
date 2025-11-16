{ lib, ... }:
{
  flake-file.inputs = {
    devenv.url = "github:cachix/devenv";
  };

  flake.aspects.direnv.homeManager = { pkgs, ... }: {
    home.packages = [ 
      pkgs.devenv 
    ];

    programs.direnv = {
      enable = lib.mkDefault true;
      mise.enable = lib.mkDefault true;
      nix-direnv.enable = lib.mkDefault false;
    };
  };
}
