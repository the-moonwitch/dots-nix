{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos;

  cadence.dependencies = {
    "desktop" = [
      # Base deps
      "desktop/xserver"
    ];

    # Subfeatures
    "desktop[gnome]" = [ "desktop" ];
  };

  flake.modules = features [
    (nixos "desktop/xserver" { services.xserver.enable = true; })
    # Subfeatures
    (nixos "desktop[gnome]" (
      { pkgs, ... }:
      {
        services = {
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
          udev.packages = [ pkgs.gnome-settings-daemon ];
        };
        environment.systemPackages = [
          pkgs.gnomeExtensions.appindicator
          pkgs.refine
          pkgs.gnome-tweaks
        ];
      }
    ))
  ];
in
{
  inherit cadence flake;
}
