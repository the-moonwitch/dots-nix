{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) system homeManager;

  cadence.dependencies.base = [
    "base/stateVersion"
    "base/hostname"
    "base/user"
    "nix"
    "unfree"
    "secrets"
    "styles"
  ];

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
  ];
in
{
  inherit flake cadence;
}
