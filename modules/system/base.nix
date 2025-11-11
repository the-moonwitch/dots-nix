{ lib, ... }:
{
  flake.aspects."system/base" = {
    nixos =
      { hostDef, ... }:
      {
        nixpkgs.config.allowUnfree = lib.mkDefault true;

        networking.hostName = lib.mkDefault hostDef.hostname;

        systemd.services."home-${hostDef.username}".restartIfChanged = lib.mkDefault true;

        users.groups."${hostDef.username}" = { };
        users.users."${hostDef.username}" = {
          description = lib.mkDefault "Ines";
          isNormalUser = true;
          group = hostDef.username;
          createHome = true;
          extraGroups = lib.mkDefault [
            "audio"
            "input"
            "networkmanager"
            "sound"
            "tty"
            "wheel"
          ];
          openssh.authorizedKeys.keys = lib.mkDefault [ ];
        };
      };

    darwin =
      { pkgs, hostDef, ... }:
      {
        nixpkgs.config.allowUnfree = lib.mkDefault true;

        system.primaryUser = lib.mkDefault hostDef.username;

        users.users.${hostDef.username} = {
          home = lib.mkDefault "/Users/${hostDef.username}";
        };

        homebrew = {
          enable = lib.mkDefault true;
          onActivation = {
            autoUpdate = lib.mkDefault true;
            cleanup = lib.mkDefault "uninstall";
            upgrade = lib.mkDefault true;
          };
          casks = lib.mkDefault [ "iterm2" ];
        };

        security.pam.services.sudo_local = {
          reattach = lib.mkDefault true;
          touchIdAuth = lib.mkDefault true;
          watchIdAuth = lib.mkDefault true;
        };
      };

    homeManager =
      { lib, hostDef, ... }:
      {
        home = {
          username = hostDef.username;
          preferXdgDirectories = lib.mkDefault true;
        };

        xdg = lib.mkIf (hostDef.class != "darwin") {
          enable = lib.mkDefault true;
          mime.enable = lib.mkDefault true;
          userDirs = {
            enable = lib.mkDefault true;
            createDirectories = lib.mkDefault true;
            desktop = lib.mkDefault null;
            templates = lib.mkDefault null;
            music = lib.mkDefault null;
            publicShare = lib.mkDefault null;
          };
        };

        # Initialize homebrew for darwin in home-manager
        programs.fish.shellInit = lib.mkIf (hostDef.class == "darwin") (
          lib.mkDefault ''
            eval (/opt/homebrew/bin/brew shellenv fish)
          ''
        );
      };
  };
}
