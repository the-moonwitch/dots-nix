{ inputs, ... }:
{
  flake-file.inputs = {
    stylix.url = "github:nix-community/stylix";
  };
  flake.modules = inputs.self.lib.mkFeature "stylix" {
    nixos = {
      imports = [ inputs.stylix.nixosModules.stylix ];
    };
    darwin = {
      imports = [ inputs.stylix.darwinModules.stylix ];
    };
    home =
      { pkgs, ... }:
      {
        stylix = {
          enable = true;
          autoEnable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        };
      };
  };
}
