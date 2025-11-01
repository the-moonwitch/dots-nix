{ lib, ... }:
{
  flake.aspects."system/state-version" = {
    nixos = { ... }: {
      system.stateVersion = lib.mkDefault "24.05";
    };

    darwin = { ... }: {
      system.stateVersion = lib.mkDefault 5;
    };

    homeManager = { ... }: {
      home.stateVersion = lib.mkDefault "24.05";
    };
  };
}
