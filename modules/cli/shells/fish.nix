{ inputs, ... }:
{
  flake.modules = {
    nixos.fish = {
      programs.fish.enable = true;
    };

    homeManager.fish =
      { pkgs, ... }:
      {
        imports = [ inputs.self.modules.homeManager.cli-utils ];

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
