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
      # zen-browser from flake input, not brew
      homebrew.casks = lib.mkDefault [
        "spotify"
      ];
    };

    homeManager = { pkgs, ... }: {
      services.ssh-agent.enable = lib.mkDefault (!pkgs.stdenvNoCC.isDarwin);

      programs.fish.shellInit = lib.mkDefault ''
        fish_add_path $(brew --prefix rustup)/bin
      '';

      programs.ssh = {
        enable = lib.mkDefault true;
        matchBlocks."*" = {
          addKeysToAgent = lib.mkForce "yes";
          identityAgent = lib.mkDefault "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        };
      };
    };
  };
}
