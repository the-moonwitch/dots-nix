{ lib, config, ... }:
{
  flake.aspects.jetbrains = {
    darwin = { ... }: {
      homebrew.casks = lib.mkDefault [ "jetbrains-toolbox" ];
    };

    homeManager =
      { pkgs, ... }:
      lib.mkMerge [
        (config.flake.lib.allowUnfree [ "jetbrains-toolbox" ])
        {
          home = lib.mkIf (!pkgs.stdenvNoCC.isDarwin) {
            packages = lib.mkDefault (with pkgs; [ jetbrains-toolbox ]);
          };
        }
      ];
  };
}
