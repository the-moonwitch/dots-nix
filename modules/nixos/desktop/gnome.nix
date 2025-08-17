{ inputs, ... }:
{
  flake.modules.nixos.desktop-gnome = {
    imports = [ inputs.self.modules.nixos.desktop ];

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
  };
}
