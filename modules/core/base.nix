{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) system homeManager darwin;

  cadence.dependencies.base = [
    "base/stateVersion"
    "base/hostname"
    "base/user"
    "base/darwin"
    "nix"
    "unfree"
    "secrets"
    "styles"
  ];

  flake-file.inputs = {
    nix-darwin.url = "github:LnL7/nix-darwin";
  };

  flake.modules = features [
    (system "base/hostname" (
      { host, ... }:
      {
        networking.hostName = host.hostname;
      }
    ))
    (system "base/user" (
      { host, home, ... }:
      {
        systemd.services."home-${host.username}".restartIfChanged = true;
        users.groups."${host.username}" = { };
        users.users."${host.username}" = {
          description = host.extra.signature or "";
          isNormalUser = true;
          group = host.username;
          createHome = true;
          extraGroups = [
            "audio"
            "input"
            "networkmanager"
            "sound"
            "tty"
            "wheel"
          ];
          home = home;
          openssh.authorizedKeys.keys = host.extra.authorizedKeys or [ ];
        };
      }
    ))
    (homeManager "base/user" (
      {
        lib,
        host,
        home,
        ...
      }:
      {
        home = {
          username = host.username;
          homeDirectory = home;
          preferXdgDirectories = true;
        };
        xdg = lib.mkIf (host.class != "darwin") {
          enable = true;
          mime.enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
            desktop = null;
            templates = null;
            music = null;
            publicShare = null;
          };
        };
      }
    ))

    (darwin "base/darwin" (
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
        home = {
          programs.fish.shellInit = ''
            eval (/opt/homebrew/bin/brew shellenv fish)
          '';
        };

        # inherit taps;
        # homebrew = {taps = taps; };
        # Todo move this elsewhere probably
        #home.packages = [ pkgs.iterm2 ];
      }))
  ];
in
{
  inherit flake cadence;
}
