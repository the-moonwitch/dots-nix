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
  };
}
