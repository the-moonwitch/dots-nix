{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) system homeManager;
  cadence.dependencies.base = [
    "base/stateVersion"
    "base/hostname"
    "base/user"

    "unfree"
    "cli"
    "nix"
    "nixos"
    "secrets"

    "styles"
    "fish[default]"
  ];

  home = host: if host.class == "darwin" then "/Users/${host.username}" else "/home/${host.username}";
  flake.modules = features [
    (system "base/hostname" (
      { host, ... }:
      {
        networking.hostName = host.hostname;
      }
    ))
    (system "base/user" (
      { host, ... }:
      {
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
          home = home host;
          openssh.authorizedKeys.keys = host.extra.authorizedKeys or [ ];
        };
      }
    ))
    (homeManager "base/user" (
      { lib, host, ... }:
      {
        home = {
          username = host.username;
          homeDirectory = home host;
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
