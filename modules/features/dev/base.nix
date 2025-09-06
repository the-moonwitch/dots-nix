{
  cadence.dependencies = {
    dev = [
      "dev/nix"
      "git"
      "nixvim"
    ];
    "dev[desktop]" = [
      "dev"

      "vscode"
      "jetbrains"
      "alacritty"
    ];
  };
}
