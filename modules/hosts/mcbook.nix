{ lib, ... }:
{
  flake.aspects.mcbook = {
    darwin = { pkgs, ... }: {
      homebrew.brews = lib.mkDefault [
        "rustup"
        "protobuf"
        "pipx"
        "uv"
      ];
      homebrew.casks = lib.mkDefault [
        "zen-browser"
        "discord"
      ];
    };

    homeManager = { pkgs, ... }: {
      services.ssh-agent.enable = lib.mkDefault (!pkgs.stdenvNoCC.isDarwin);

      programs.fish.shellInit = ''
        fish_add_path $(brew --prefix rustup)/bin
      '';

      programs.ssh = {
        enable = lib.mkDefault true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
          forwardAgent = lib.mkDefault false;
          serverAliveInterval = lib.mkDefault 60;
          serverAliveCountMax = lib.mkDefault 3;
          compression = lib.mkDefault false;
          addKeysToAgent = lib.mkForce "yes";
          hashKnownHosts = lib.mkDefault false;
          userKnownHostsFile = lib.mkDefault "~/.ssh/known_hosts";
          controlMaster = lib.mkDefault "auto";
          controlPath = lib.mkDefault "~/.ssh/master-%r@%n:%p";
          controlPersist = lib.mkDefault "10m";
          identityAgent = lib.mkDefault ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
        };
      };
    };
  };
}
