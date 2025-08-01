{ inputs, ... }:
{
  flake.modules.nixos.base = {
    imports = [
      inputs.self.modules.nixos.hardware
      inputs.self.modules.nixos.boot
      inputs.self.modules.nixos.locale
      inputs.self.modules.nixos.networking
      inputs.self.modules.nixos.nix-index
      inputs.self.modules.nixos.nix-settings
      inputs.self.modules.nixos.power-management
      inputs.self.modules.nixos.secrets
      inputs.self.modules.nixos.unfree
    ];

    system.stateVersion = "25.05";
  };
}
