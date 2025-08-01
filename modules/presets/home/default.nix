{ inputs, ... }:
{
  flake.modules.homeManager.base.imports =
    with inputs.self.modules.homeManager; [
      secrets
      fish
      git
      nixvim
      cli-utils
      nix-index
    ];
}
