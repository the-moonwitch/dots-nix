{ inputs, ... }:
let
  hmModule = class: {
    imports = [ inputs.home-manager."${class}Modules".home-manager ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
in
{
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
  };
  flake.modules = inputs.self.lib.mkFeature "home-manager" {
    nixos = hmModule "nixos";
    darwin = hmModule "darwin";
  };
}
