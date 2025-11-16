{ lib, inputs, ... }:
let
  catppuccinConfig = {
    enable = lib.mkDefault true;
    flavor = lib.mkDefault "macchiato";
    accent = lib.mkDefault "mauve";
  };

  stylixConfig = pkgs: {
    enable = lib.mkDefault true;
    autoEnable = lib.mkDefault true;
    polarity = lib.mkDefault "dark";
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF;
        name = "Maple Mono NF Light";
      };
      sizes = {
        applications = lib.mkDefault 11;
        terminal = lib.mkDefault 11;
        desktop = lib.mkDefault 11;
        popups = lib.mkDefault 11;
      };
    };
  };
in
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

      catppuccin = catppuccinConfig;
      stylix = stylixConfig pkgs;
    };

    darwin = { pkgs, ... }: {
      imports = [
        inputs.stylix.darwinModules.stylix
      ];

      stylix = stylixConfig pkgs;
    };

    homeManager = { pkgs, hostDef, ... }: {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = catppuccinConfig // {
        gtk.icon.enable = lib.mkDefault (hostDef.class == "nixos");
      };

      # Stylix is configured at the system level and propagates to home-manager
      # Disable Stylix for programs where Catppuccin provides theming
      stylix.targets = lib.genAttrs [
        "fzf"
        "bat"
        "starship"
      ] (lib.const {enable = lib.mkDefault false;});
      programs.vscode.profiles.default.userSettings."workbench.colorTheme" = lib.mkOverride 99 "Catppuccin Macchiato";
    };
  };
}
