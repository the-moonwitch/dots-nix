{
  flake.dependencies = {
    dev = [
      "dev-nix"
      "jujutsu"
    ];
    "dev/desktop" = [
      "dev"
      "vscode"
      "jetbrains"
      "alacritty"
    ];
  };
}
