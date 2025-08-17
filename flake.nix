# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Ninix";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  inputs = {
    allfollow = {
      url = "github:spikespaz/allfollow";
    };
    devshell = {
      url = "github:numtide/devshell";
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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    opnix = {
      url = "github:brizzbuzz/opnix";
    };
    rust-overlay = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:oxalica/rust-overlay";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

}
