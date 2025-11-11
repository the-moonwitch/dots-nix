{ lib, ... }:
{
  flake.aspects.podman = {
    nixos = { pkgs, ... }: {
      virtualisation.containers.enable = true;
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
        dockerSocket.enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };

      environment.systemPackages = with pkgs; [
        podman-compose
      ];
    };

    darwin = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        colima
        docker
        docker-compose
      ];
    };
  };
}
