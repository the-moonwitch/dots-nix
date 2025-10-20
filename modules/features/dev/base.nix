{
  cadence.dependencies = {
    dev = [
      "dev/nix"
      "nodejs"
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
