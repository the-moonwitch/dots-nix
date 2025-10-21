{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos darwin homeManager;

  fontDefs = pkgs: {
    # Breaks??
    sansSerif = {
      package = pkgs.inter;
      name = "Inter";
    };
    serif = {
      package = pkgs.aleo-fonts;
      name = "Aleo";
    };
    monospace = {
      package = pkgs.maple-mono.NF;
      name = "Maple Mono NF";
    };
  };

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
    # Breaks other package caches
    # cache.enable = true;
  };

  flake-file.inputs = {
    stylix.url = "github:nix-community/stylix";
    catppuccin.url = "github:catppuccin/nix";
  };

  flake.modules = features [
    (nixos "stylix" (
      { pkgs, lib, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];

        fonts.packages =
          (lib.mapAttrsToList (_: { package, ... }: package) (fontDefs pkgs))
          ++ [
            pkgs.atkinson-hyperlegible-next
            pkgs.jetbrains-mono
          ];
      }
    ))

    (darwin "stylix" { imports = [ inputs.stylix.darwinModules.stylix ]; })

    (homeManager "stylix" (
      { pkgs, lib, ... }:
      let
        defaultFonts = fontDefs pkgs;
      in
      {
        imports = [ inputs.stylix.homeModules.stylix ];

        home.packages = lib.mapAttrsToList (_: { package, ... }: package) (
          fontDefs pkgs
        );

        fonts.fontconfig = {
          enable = true;
          hinting = "slight";
          defaultFonts = builtins.mapAttrs (_: { name, ... }: [ name ]) defaultFonts;
        };

        stylix = {
          enable = true;
          polarity = "dark";
          autoEnable = false;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-${catppuccin.flavor}.yaml";
          targets = {
            alacritty.enable = true;
            vencord.enable = true;
            eog.enable = true;
            fish.enable = true;
            font-packages.enable = true;
            fontconfig.enable = true;
            gedit.enable = true;
            gnome-text-editor.enable = true;
            gnome.enable = true;
            gtksourceview.enable = true;
            mpv.enable = true;
            neovim.enable = true;
            nixvim.enable = true;
            nixos-icons.enable = true;
            rio.enable = true;
            tmux.enable = true;
            # vscode = {
            #   enable = true;
            #   # profileNames = [ "default" ];
            # };
            xresources.enable = true;
            zen-browser.enable = true;

            # Catppuccin conflicts
            foot.enable = false;
            fzf.enable = false;
            qt.enable = false;

            # TODO Nixos
            # grub.enable = true;
            # lightdm.enable = true;
            # plymouth.enable = true;
          };
          icons = {
            enable = true;
            package = pkgs.catppuccin-papirus-folders.override {
              flavor = catppuccin.flavor;
              accent = catppuccin.accent;
            };
            dark = "Papirus-Dark";
            light = "Papirus-Light";
          };
          fonts = defaultFonts;
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
        catppuccin = {
          inherit (catppuccin) flavor accent enable;
          vscode.profiles.default = {
            enable = false;
          };
          gtk.icon.enable = false;
        };

        gtk = {
          enable = true;
          theme = {
            package = (
              pkgs.catppuccin-gtk.override {
                variant = catppuccin.flavor;
                accents = [ catppuccin.accent ];
              }
            );
            name = "catppuccin-${catppuccin.flavor}-${catppuccin.accent}-standard";
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "kvantum";
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
