{ inputs, ... }:
{
  flake.modules.nixos.preset-desktop = {
    imports = with inputs.self.modules.nixos; [
      base
      audio
      desktop-gnome
    ];
  };
}
