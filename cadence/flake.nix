{
  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
  };

  description = "Compact and Declarative Nix Config Elaborator";
  outputs = inputs: import ./modules inputs;
}
