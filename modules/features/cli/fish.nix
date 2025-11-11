{ lib, ... }:
{
  # TODO: extract common parts

  flake.aspects.fish = {
    nixos = { pkgs, hostDef, ... }: {
      programs.fish.enable = lib.mkDefault true;

      users.users.${hostDef.username}.shell = pkgs.fish;
      users.users.root.shell = pkgs.fish;
    };

    darwin =
      { pkgs, hostDef, ... }:
      {
        programs.fish.enable = lib.mkDefault true;

        environment.shells = lib.mkDefault [
          pkgs.fish
          pkgs.zsh
          pkgs.bashInteractive
        ];

        users.users.${hostDef.username}.shell = pkgs.fish;
        users.users.root.shell = pkgs.fish;
      };

    homeManager = { pkgs, config, lib, ... }: {
      programs.fish = {
        enable = lib.mkDefault true;
        plugins = lib.mkDefault [
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair;
          }
        ];
        shellInit = lib.mkDefault ''
          fish_add_path ~/.local/bin
        '';
        shellAliases = lib.mkDefault {
          ".." = "cd ..";
          "..." = "cd ../..";
          cat = "bat";
          ls = "eza";
          grep = "rg";
          cd = "z";
        };
        # Conditionally add fastfetch greeting if fastfetch is enabled
        functions.fish_greeting = lib.mkIf config.programs.fastfetch.enable {
          body = lib.mkDefault "fastfetch";
        };
      };
    };
  };
}
