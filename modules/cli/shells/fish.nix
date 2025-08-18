{ inputs, ... }:
{
  flake.dependencies.fish = [ "cli-utils" ];
  flake.modules = inputs.self.lib.mkFeature "fish" {
    nixos = {
      programs.fish.enable = true;
    };

    home =
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
              grep = "ag";
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
      };
  };
}
