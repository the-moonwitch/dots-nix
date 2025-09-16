{
  cadence.dependencies = {
    dev = [
      "dev/nix"
      "git"
      "nixvim"
      "devenv"
    ];
    "dev[desktop]" = [
      "dev"

      "vscode"
      "jetbrains"
      "alacritty"
      "foot"
    ];
  };
}
