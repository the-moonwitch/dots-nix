{ inputs, ... }:
{

  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
  };
  flake.modules = inputs.self.lib.mkNixosFeature "home-manager" {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
