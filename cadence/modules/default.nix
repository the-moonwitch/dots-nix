inputs: {
  flakeModules.default =
    { inputs, lib, ... }:
    {
      flake-file.inputs.home-manager.url = lib.mkDefault "github:nix-community/home-manager";

      imports = [
        inputs.flake-parts.flakeModules.modules
        inputs.flake-file.flakeModules.dendritic
        ./configurations.nix
        ./formatter.nix
        ./options.nix
      ];

      flake.features = { };
    };

  lib = import ./lib.nix inputs;
}
