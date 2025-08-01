{ inputs, ... }:
{
  flake.modules.homeManager.preset-desktop = {
    imports = with inputs.self.modules.homeManager; [
      base
      firefox

      # TODO: Decide on one
      alacritty
      foot

      vscode
    ];
  };
}
