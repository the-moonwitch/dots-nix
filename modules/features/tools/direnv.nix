{ lib, ... }:
{
  flake.aspects.direnv.homeManager = { pkgs, ... }: {
    home.packages = lib.mkDefault [ pkgs.devenv ];

    programs.direnv = {
      enable = lib.mkDefault true;
      mise.enable = lib.mkDefault true;
      nix-direnv.enable = lib.mkDefault false;
      config.global = {
        strict_env = lib.mkDefault true;
      };
    };
  };
}
