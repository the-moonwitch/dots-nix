{
  flake.hosts = {
    moth = {
      hostname = "moth";
      system = "x86_64-linux";
      class = "nixos";
      username = "ines";
      features = [
        "preset/desktop/personal"
        "dev/desktop"
      ];
    };
    MAC-QXGYWVX = {
      hostname = "MAC-QXGYWVX";
      system = "aarch64-darwin";
      class = "darwin";
      username = "ines";
      features = [
        "preset/desktop"
        "dev/desktop"
        "browser/firefox"
      ];
    };
  };
}
