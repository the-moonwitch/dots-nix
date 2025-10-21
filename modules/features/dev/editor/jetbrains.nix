{ inputs, lib, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) homeManager darwin;

  flake.modules = features [
    (homeManager "jetbrains" (
      { pkgs, ... }:
      {
        imports = [
          {
            home = lib.mkIf (!pkgs.stdenvNoCC.isDarwin) {
              packages = with pkgs; [ jetbrains-toolbox ];
            };
          }
          # TODO move this elsewhere
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
      }
    ))

    (darwin "jetbrains" { homebrew.casks = [ "jetbrains-toolbox" ]; })
  ];
in
{
  inherit flake;
}
