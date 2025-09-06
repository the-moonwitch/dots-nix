{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos darwin homeManager;

  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  flake.modules = features [
    (nixos "secrets" {
      imports = [ inputs.opnix.nixosModules.default ];
      # services.onepassword-secrets = {
      #   enable = true;
      # };
    })

    (darwin "secrets" {
      imports = [ inputs.opnix.darwinModules.default ];
      # services.onepassword-secrets = {
      #   enable = true;
      # };
    })

    (homeManager "secrets" {
      programs.gpg = {
        enable = true;
      };
    })

    (darwin "opass-gui" { homebrew.casks = [ "1password" ]; })
  ];
in
{
  inherit flake flake-file;
}
