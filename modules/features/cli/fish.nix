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
    "fish[fetch]" = [ "fish" ];
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

    (homeManager "fish[fetch]" (
      { lib, ... }:
      {

        programs.fish.functions.fish_greeting.body = ''
          fastfetch
        '';
        programs.fastfetch = {
          enable = true;
          settings =
            let
              hlColor = "bold_magenta";
            in
            {
              logo = {
                type = "small";
                padding.top = 4;
              };
              display = {
                separator = " ∷ ";
                color.separator = hlColor;
              };
              modules =
                let
                  pad =
                    str:
                    let
                      width = 8;
                      len = builtins.stringLength str;
                    in
                    if len < width then (lib.strings.replicate (width - len) " ") + str else str;
                  padded = str: {
                    type = str;
                    key = pad str;
                  };

                in
                [
                  {
                    type = "title";
                    format = "    {user-name-colored} {at-symbol-colored} {host-name-colored}";
                    color.user = hlColor;
                    color.host = hlColor;
                  }
                  (padded "uptime")
                  {
                    type = "custom";
                    format = "        ╶═╴";
                    outputColor = hlColor;
                  }
                  {
                    type = "os";
                    key = pad "system";
                  }
                  (padded "kernel")
                  (padded "host")
                  {
                    type = "packages";
                    key = pad "pkg";
                  }
                  {
                    type = "shell";
                    key = pad "sh";
                  }
                  {
                    type = "cpu";
                    key = pad "cpu";
                    temp = true;
                    showPeCoreCount = true;
                  }
                  {
                    type = "gpu";
                    key = pad "gpu";
                    driverSpecific = true;
                    temp = true;
                  }
                  {
                    type = "disk";
                    key = pad "disk";
                    folders = [ "/" ];
                  }
                  (padded "memory")
                ];
            };
        };
      }
    ))
  ];
in
{
  inherit flake cadence;
}
