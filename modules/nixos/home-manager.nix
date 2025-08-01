{ inputs, ... }:
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    flake-file.inputs = {
      home-manager.url = "github:nix-community/home-manager";
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
