{ inputs, lib, ... }:
{
  flake.modules = inputs.self.lib.mkFeature "jetbrains" {
    home =
      { pkgs, ... }:
      {
        imports = [
          {

            home = lib.mkIf (!pkgs.stdenvNoCC.isDarwin) {
              packages = with pkgs; [ jetbrains-toolbox ];
            };
          }
          {

            home = {
              packages = with pkgs; [
                pre-commit
                just
                mise
              ];
            };
          }
        ];
      };
    nixos = inputs.self.lib.declareUnfree [ "jetbrains-toolbox" ];
    darwin = {
      imports = [ ];
      homebrew.casks = [ "jetbrains-toolbox" ];
    };
  };
}
