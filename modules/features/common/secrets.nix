{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos darwin homeManager;
  secrets = {

  };

  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  flake.modules = features [
    (nixos "secrets" {
      imports = [ inputs.opnix.nixosModules.default ];
      services.onepassword-secrets = {
        # enable = true;
        inherit secrets;
      };
      programs._1password-gui.enable = true;
    })

    (darwin "secrets" {
      imports = [ inputs.opnix.darwinModules.default ];
      services.onepassword-secrets = {
        # enable = true;
        inherit secrets;
      };
    })

    (homeManager "secrets" {
      imports = [ inputs.opnix.homeManagerModules.default ];

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
