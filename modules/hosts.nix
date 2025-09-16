{ self, ... }:
let
  inherit (self.lib) hosts;
in
{
  cadence.hosts = hosts {
    moth.features = [
      "base"
      "desktop[gnome]"
      "desktop[personal]"
      "dev[desktop]"
      "dev/python"
      "nix-ld"
    ];
  };
}
