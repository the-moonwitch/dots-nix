{ inputs, ... }:
{
  flake.dependencies.desktop-gnome = [ "desktop" ];

  flake.modules = inputs.self.lib.mkFeature "desktop-gnome" {
    nixos.services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
