{ ... }:
{
  flake.hosts = {
    mcbook = {
      hostname = "MAC-QXGYWVX";
      system = "aarch64-darwin";
      class = "darwin";
      username = "ines";
      aspects = [
        "base"
        "cli"
        "nixvim"
        "vscode"
        "obsidian"
        "iterm2"
        "podman"
        "mcbook"
      ];
    };

    moth = {
      hostname = "moth";
      system = "x86_64-linux";
      class = "nixos";
      username = "ines";
      aspects = [
        "base"
        "cli"
        "nixvim"
        "vscode"
        "obsidian"
        "foot"
        "podman"
        "system/nixos/hardware"
        "system/nixos/power-management"
        "system/nixos/boot"
        "system/nixos/networking"
        "system/nixos/locale"
        "system/nixos/audio"
        "system/nixos/printing"
        "system/nixos/desktop"
        "system/nixos/gnome"
        "system/nixos/amdcpu"
        "system/nixos/nix-ld"
        "moth"
      ];
    };
  };
}
