{ inputs, ... }:
let

  flake-file.inputs = {
    nix-darwin.url = "github:LnL7/nix-darwin";
  };

  flake.modules = inputs.self.lib.mkDarwinFeature "base" {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      nix-darwin-pkgs
    ];

    services.nix-daemon.enable = true;
  };

  nix-darwin-pkgs =
    { pkgs, ... }:
    {
      environment.systemPackages = with inputs.nix-darwin.packages.${pkgs.system}; [
        darwin-option
        darwin-rebuild
        darwin-version
        darwin-uninstaller
      ];
    };
in
{
  inherit flake flake-file;
}
