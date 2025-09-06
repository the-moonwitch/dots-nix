{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) system;
  cadence.dependencies.base = [
    "base/hostname"
    "base/user"

    "nix"
    "nixos"
  ];
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
        users.users."${host.username}" = {
          description = host.extra.signature or "";
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
          home = if host.class == "darwin" then "/Users/${host.username}" else "/home/${host.username}";
          openssh.authorizedKeys.keys = host.extra.authorizedKeys or [ ];
        };
      }
    ))
  ];
in
{
  inherit flake cadence;
}
