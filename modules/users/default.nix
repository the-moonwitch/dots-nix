{ inputs, ... }:
let
  me = inputs.self.const.me;
  mkFeature = inputs.self.lib.mkFeature;
in
{
  flake.dependencies.base = [ "fish" ];
  flake.modules = mkFeature "base" {
    nixos =
      { pkgs, ... }:
      {
        users.users."${me.username}" = {
          description = me.signature;
          isNormalUser = true;
          createHome = true;
          extraGroups = [
            "audio"
            "input"
            "networkmanager"
            "sound"
            "tty"
            "wheel"
          ];
          shell = pkgs.fish;
          openssh.authorizedKeys.keys = me.authorizedKeys;
        };
        users.users.root = {
          shell = pkgs.fish;
        };
      };

    home =
      { pkgs, ... }:
      {
        home = {
          username = me.username;
          homeDirectory = "${
            if pkgs.stdenvNoCC.isDarwin then "/Users/" else "/home/"
          }${me.username}";
        };

        xdg = {
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
      };
  };
}
