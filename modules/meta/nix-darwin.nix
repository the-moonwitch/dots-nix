{ inputs, ... }:
{
  flake-file.inputs = {
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  flake.modules = inputs.self.lib.mkDarwinFeature "base" (
    { pkgs, ... }:
    let
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
    in
    {
      environment.systemPackages = with inputs.nix-darwin.packages.${pkgs.system}; [
        darwin-option
        darwin-rebuild
        darwin-version
        darwin-uninstaller
      ];

      services.nix-daemon.enable = true;
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = inputs.const.me.username;
      };

      inherit taps;
      homebrew.taps = taps;

      mutableTaps = false;

      # Todo move this elsewhere probably
      home.packages = [ pkgs.iterm2 ];
    }
  );
}
