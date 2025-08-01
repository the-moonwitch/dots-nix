{ inputs, ... }:
let
  me = inputs.self.const.me;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.nixos.fish ];

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

  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      platformChecks = inputs.self.lib.platformChecks pkgs;
    in
    {

      home = {
        username = me.username;
        homeDirectory = platformChecks.darwinOr "/Users/${me.username}" "/home/${me.username}";
        stateVersion = "25.05";
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
}
