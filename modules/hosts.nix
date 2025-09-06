{ self, ... }:
let
  inherit (self.lib) hosts;
in
{
  cadence.hosts = hosts {
    moth.features = [
      "desktop[gnome]"
      "desktop[personal]"
      "dev[desktop]"
    ];
  };
}
