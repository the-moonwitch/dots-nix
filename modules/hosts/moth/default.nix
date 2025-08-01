{ inputs, ... }:
let
  username = inputs.self.const.me.username;
  hostname = "moth";
  system = "x86_64-linux";
in
{
  flake.modules.nixos.moth.nixpkgs.hostPlatform = "x86_64-linux";

  flake.nixosConfigurations."${hostname}" = inputs.self.lib.nixosConfiguration {
    inherit hostname system;
  };

  flake.homeConfigurations."${username}@{hostname}" =
    inputs.self.lib.homeConfiguration
      { inherit hostname; };
}
