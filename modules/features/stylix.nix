{ inputs, ... }:
let
  stylixModule =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      };
    };

in
{
  flake-file.inputs = {
    stylix.url = "github:nix-community/stylix";
  };
  flake.modules = inputs.self.lib.mkFeature "stylix" {
    nixos = {
      imports = [
        inputs.stylix.nixosModules.stylix
        stylixModule
      ];
    };
    darwin = {
      imports = [
        inputs.stylix.darwinModules.stylix
        stylixModule
      ];
    };
    home =
      { pkgs, ... }:
      {
        stylix = {
          enable = true;
          autoEnable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
          targets = {
            firefox = {
              enable = !pkgs.stdenvNoCC.isDarwin;
              profileNames = [
                "default"
                "Work"
                "Personal"
              ];
            };
          };
        };
      };
  };
}
