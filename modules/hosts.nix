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
    MAC-QXGYWVX = {
      hostname = "MAC-QXGYWVX";
      system = "aarch64-darwin";
      class = "darwin";
      username = "ines";
      features = [
        "preset/desktop"
        "dev/desktop"
      ];
    };
  };
}
