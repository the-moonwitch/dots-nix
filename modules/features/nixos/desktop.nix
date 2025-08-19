{ inputs, ... }:
{
  flake.dependencies."desktop" = [
    # Base deps
    "desktop/xserver"
    # Default desktop
    "desktop/gnome"
  ];

  imports = [
    {
      flake.modules = inputs.self.lib.mkNixosFeature "desktop/xserver" {
        services.xserver.enable = true;
      };
    }
    {
      flake.modules = inputs.self.lib.mkNixosFeature "desktop/gnome" {
        services = {
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
        };
      };
    }
  ];
}
