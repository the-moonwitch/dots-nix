{
  flake.dependencies.base = [
    # Setup
    "boot"
    "home-manager"
    "hardware"
    "locale"
    "networking"
    "nix"
    "power-management"
    "secrets"
    "unfree"

    # Common software
    "fish"
    "git"
    "nixvim"
    "cli-utils"
    "nix"
  ];
}
