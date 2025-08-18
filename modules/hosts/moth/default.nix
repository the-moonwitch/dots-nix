{ inputs, ... }:
let
  hostname = "moth";
  system = "x86_64-linux";
  class = "nixos";
  username = "ines";
  features = [ "preset-desktop-personal" ];
in
{
  flake.nixosConfigurations = inputs.self.lib.mkHost {
    inherit
      hostname
      system
      class
      username
      features
      ;
  };
}
