{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkNixosFeature "desktop" {
    services.xserver.enable = true;
  };
}
