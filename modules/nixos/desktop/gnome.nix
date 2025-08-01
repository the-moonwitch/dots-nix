{ flake, ... }:
{
  flake.modules.nixos.desktop-gnome = {
    imports = [ flake.modules.nixos.desktop ];

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
  };
}
