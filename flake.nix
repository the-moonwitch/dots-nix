# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Ninix";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  inputs = {
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    flake-aspects = {
      url = "github:vic/flake-aspects";
    };
    flake-file = {
      url = "github:vic/flake-file";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    import-tree = {
      url = "github:vic/import-tree";
    };
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    nixpkgs-lib = {
      follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    opnix = {
      url = "github:brizzbuzz/opnix";
    };
    stylix = {
      url = "github:nix-community/stylix";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
  };

}
