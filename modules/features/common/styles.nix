{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos darwin homeManager;

  cadence.dependencies = {
    "styles" = [
      "stylix"
      "catppuccin"
    ];
  };

  # stylixModule =
  #   { pkgs, ... }:
  #   {
  #     stylix = {
  #       enable = true;
  #       autoEnable = true;
  #       base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  #     };
  #   };
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "mauve";
    cache.enable = true;
  };

  flake-file.inputs = {
    stylix.url = "github:nix-community/stylix";
    catppuccin.url = "github:catppuccin/nix";
  };

  flake.modules = features [
    (nixos "stylix" { imports = [ inputs.stylix.nixosModules.stylix ]; })

    (darwin "stylix" { imports = [ inputs.stylix.darwinModules.stylix ]; })

    (homeManager "stylix" (
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.homeModules.stylix ];
        home.packages = [
          pkgs.aleo-fonts
          pkgs.maple-mono.variable
        ];

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
          icons = {
            enable = true;
            package = (
              pkgs.catppuccin-papirus-folders.override {
                flavor = "macchiato";
                accent = "mauve";
              }
            );
            dark = "Papirus-Dark";
            light = "Papirus-Light";
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
    (nixos "catppuccin" {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];
      inherit catppuccin;
    })
    (homeManager "catppuccin" (
      { pkgs, ... }:
      {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];
        inherit catppuccin;

        home.packages = with pkgs; [
          (catppuccin-kvantum.override {
            accent = "Blue";
            variant = "Macchiato";
          })
          libsForQt5.qtstyleplugin-kvantum
          libsForQt5.qt5ct
          (pkgs.catppuccin-gtk.override {
            variant = "macchiato";
            accents = "mauve";
          })
        ];

        gtk = {
          enable = true;

        };

        qt = {
          enable = true;
          platformTheme = "qtct";
          style.name = "kvantum";
        };

        xdg.configFile."Kvantum/kvantum.kvconfig".source =
          (pkgs.formats.ini { }).generate "kvantum.kvconfig"
            { General.theme = "Catppuccin-Macchiato-Mauve"; };
      }
    ))
  ];
in
{
  inherit flake flake-file cadence;
}
