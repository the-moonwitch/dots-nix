{ lib, inputs, ... }:
{
  flake-file.inputs.nixvim.url = "github:nix-community/nixvim";

  flake.aspects.nixvim.homeManager = { pkgs, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = lib.mkDefault true;
      viAlias = lib.mkDefault true;
      vimAlias = lib.mkDefault true;
      vimdiffAlias = lib.mkDefault true;
      defaultEditor = lib.mkDefault true;

      # Colorscheme - works with Stylix
      colorschemes.catppuccin = {
        enable = lib.mkDefault true;
        settings.flavour = lib.mkDefault "mocha";
      };

      # Essential options
      opts = {
        number = true;
        relativenumber = true;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        smartindent = true;
        wrap = false;
        ignorecase = true;
        smartcase = true;
        termguicolors = true;
        signcolumn = "yes";
        cursorline = true;
        scrolloff = 8;
        splitright = true;
        splitbelow = true;
        clipboard = "unnamedplus";
        mouse = "a";
        undofile = true;
        swapfile = false;
        updatetime = 250;
        completeopt = "menu,menuone,noselect";
        inccommand = "split"; # Live substitution preview
      };

      globals.mapleader = " ";

      # Treesitter for syntax highlighting
      plugins.treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # LSP
      plugins.lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # Nix
          ts_ls.enable = true; # TypeScript/JavaScript
          pyright.enable = true; # Python
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          lua_ls.enable = true;
        };
      };

      # Autocompletion
      plugins.cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      plugins.luasnip.enable = true;

      # Copilot
      plugins.copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = true;
          };
          panel.enabled = false;
        };
      };

      # Statusline
      plugins.lualine = {
        enable = true;
        settings.options = {
          theme = "catppuccin";
          globalstatus = true;
        };
      };

      # Telescope fuzzy finder
      plugins.telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      # File explorer
      plugins.nvim-tree.enable = true;

      # Git signs
      plugins.gitsigns.enable = true;

      # Auto pairs
      plugins.nvim-autopairs.enable = true;

      # Comment toggling
      plugins.comment.enable = true;

      # Which-key for keybinding hints
      plugins.which-key.enable = true;

      # Web devicons for file type icons
      plugins.web-devicons.enable = true;

      # Formatting with ruff for Python
      plugins.conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "alejandra" ];
            python = [ "ruff_format" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
            rust = [ "rustfmt" ];
          };
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
        };
      };

      extraPackages = with pkgs; [
        alejandra
        ruff
        prettier
        rustfmt
        ripgrep
        fd
      ];
    };
  };
}
