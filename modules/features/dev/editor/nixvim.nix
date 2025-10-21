{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;

  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  flake.modules = homeManager "nixvim" {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
  };
in
{
  inherit flake flake-file;
}
