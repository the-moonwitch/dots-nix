{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos darwin homeManager;

  stylixModule =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      };
    };

  flake-file.inputs = {
    stylix.url = "github:nix-community/stylix";
  };

  flake.modules = features [
    (nixos "stylix" {
      imports = [
        inputs.stylix.nixosModules.stylix
        stylixModule
      ];
    })

    (darwin "stylix" {
      imports = [
        inputs.stylix.darwinModules.stylix
        stylixModule
      ];
    })

    (homeManager "stylix" (
      { pkgs, ... }:
      {
        stylix = {
          enable = true;
          autoEnable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
          targets = {
            firefox = {
              enable = true;
              profileNames = [ "default" ];
            };
          };
          fonts = {
            serif = {
              package = pkgs.aleo-fonts;
              name = "Aleo";
            };
            monospace = {
              package = pkgs.maple-mono.variable;
              name = "Maple Mono";
            };
          };
        };
      }
    ))
  ];
in
{
  inherit flake flake-file;
}
