{ lib, inputs, ... }:
{
  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  flake.aspects.nixvim.homeManager = { ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = lib.mkDefault true;
      viAlias = lib.mkDefault true;
      vimAlias = lib.mkDefault true;
      vimdiffAlias = lib.mkDefault true;
      defaultEditor = lib.mkDefault true;
    };
  };
}
