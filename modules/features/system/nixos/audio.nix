{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) nixos;
  flake.modules = nixos "audio" {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
in
{
  inherit flake;
}
