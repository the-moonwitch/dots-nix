{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
in
{
  flake = {
    dependencies.base = [
      "base/stateVersion"
      "base/hostname"
      "base/homePkgs"

      "nix"
      "nixos"
    ];
    modules = features [
      (feature "base/stateVersion" {
        nixos = {
          system.stateVersion = "25.05";
        };

        darwin = {
          system.stateVersion = 6;
        };

        homeManager = {
          home.stateVersion = "25.05";
        };
      })
      (feature.system "base/hostname" (
        { host, ... }:
        {
          networking.hostName = host.hostname;
        }
      ))
      (feature.system "base/homePkgs" {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      })
    ];
  };
}
