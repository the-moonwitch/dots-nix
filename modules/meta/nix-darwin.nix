{ inputs, ... }:
{
  flake-file.inputs = {
    nix-darwin.url = "github:LnL7/nix-darwin";
  };

  flake.modules = inputs.self.lib.mkFeature "base" {
    home = {
      programs.fish.shellInit = ''
        eval (/opt/homebrew/bin/brew shellenv fish)
      '';
    };
    darwin =
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = with inputs.nix-darwin.packages.${pkgs.system}; [
          darwin-option
          darwin-rebuild
          darwin-version
          darwin-uninstaller
        ];

        system.primaryUser = inputs.self.const.me.username;

        users.users.${inputs.self.const.me.username} = {
          home = "/Users/${inputs.self.const.me.username}";
          shell = pkgs.fish;
        };

        homebrew = {
          enable = true;
          onActivation = {
            autoUpdate = true;
            cleanup = "uninstall";
            upgrade = true;
          };
          casks = [ "iterm2" ];
        };

        security.pam.services.sudo_local = {
          reattach = true;
          touchIdAuth = true;
          watchIdAuth = true;
        };

        # inherit taps;
        # homebrew = {taps = taps; };
        # Todo move this elsewhere probably
        #home.packages = [ pkgs.iterm2 ];
      };
  };
}
