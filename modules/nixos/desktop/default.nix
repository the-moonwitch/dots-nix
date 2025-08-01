{ ... }:
{
  flake.modules.nixos.desktop = {
    services.xserver.enable = true;
  };
}
