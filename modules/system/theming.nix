{ lib, inputs, ... }:
{
  flake-file.inputs = {
    stylix.url = "github:nix-community/stylix";
    catppuccin.url = "github:catppuccin/nix";
  };

  flake.aspects."system/theming" = {
    nixos = { pkgs, ... }: {
      imports = [
        inputs.stylix.nixosModules.stylix
        inputs.catppuccin.nixosModules.catppuccin
      ];

      stylix = {
        enable = lib.mkDefault true;
        autoEnable = lib.mkDefault true;
        polarity = lib.mkDefault "dark";
        base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      };
    };

    darwin = { pkgs, ... }: {
      imports = [
        inputs.stylix.darwinModules.stylix
      ];

      stylix = {
        enable = lib.mkDefault true;
        autoEnable = lib.mkDefault true;
        polarity = lib.mkDefault "dark";
        base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      };
    };

    homeManager = { pkgs, ... }: {
      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin
      ];

      # Stylix is configured at the system level and propagates to home-manager
    };
  };
}
