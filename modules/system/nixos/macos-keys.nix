{ lib, ... }:
{
  flake.aspects."system/nixos/macos-keys".nixos = {
    services.keyd = {
      enable = lib.mkDefault true;
      keyboards.default = {
        ids = lib.mkDefault [ "*" ];
        settings = lib.mkDefault {
          # ...
        };
      };
    };
  };
}
