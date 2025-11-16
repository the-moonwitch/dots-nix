{ lib, config, ... }:
{
  flake.aspects.vscode = lib.mkMerge [
    (config.flake.lib.allowUnfreeFor [ "vscode" ])
    {
      homeManager = { pkgs, ... }: {
        programs.vscode = {
          enable = lib.mkDefault true;

          profiles.default = {
            extensions = with pkgs.vscode-extensions; [
              jnoortheen.nix-ide
              rust-lang.rust-analyzer
              vscodevim.vim
              github.copilot
              github.copilot-chat
            ];

            userSettings = {
              "nix.enableLanguageServer" = lib.mkDefault true;
              "nix.serverPath" = lib.mkDefault "nil";
              "nix.formatterPath" = lib.mkDefault "nixfmt";
              "rust-analyzer.check.command" = lib.mkDefault "clippy";
              "vim.useSystemClipboard" = lib.mkDefault true;
              "vim.hlsearch" = lib.mkDefault true;
              "github.copilot.enable" = lib.mkDefault {
                "*" = true;
              };
              "[nix]" = lib.mkDefault {
                "editor.defaultFormatter" = "jnoortheen.nix-ide";
                "editor.formatOnSave" = true;
              };
            };
          };
        };
      };
    }
  ];
}
