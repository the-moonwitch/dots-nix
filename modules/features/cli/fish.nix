{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature)
    nixos
    darwin
    homeManager
    system
    ;

  cadence.dependencies = {
    "fish" = [ "cli-utils" ];
    "fish[default]" = [ "fish" ];
  };

  flake.modules = features [
    (nixos "fish" { programs.fish.enable = true; })

    (system "fish[default]" (
      { host, pkgs, ... }:
      {
        users.users."${host.username}".shell = pkgs.fish;
        users.users.root.shell = pkgs.fish;
      }
    ))

    (darwin "fish" (
      { pkgs, ... }:
      {
        programs.fish.enable = true;

        environment.shells = [
          pkgs.fish
          pkgs.zsh
          pkgs.bashInteractive
        ];
      }
    ))

    (homeManager "fish" (
      { pkgs, ... }:
      {
        home.shell.enableFishIntegration = true;

        programs = {
          fish = {
            enable = true;
            plugins = [
              {
                name = "autopair";
                src = pkgs.fishPlugins.autopair;
              }
            ];
            shellAliases = {
              ".." = "cd ..";
              "..." = "cd ../..";
              cat = "bat";
              ls = "eza";
              grep = "rg";
              cd = "z";
            };
          };

          # Prompt
          starship = {
            enable = true;
            enableInteractive = true;
            enableFishIntegration = true;
            settings = { };
          };
        };
      }
    ))
  ];
in
{
  inherit flake cadence;
}
