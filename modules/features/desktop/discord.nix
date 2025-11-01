{ lib, config, ... }:
{
  flake.aspects.discord.homeManager =
    { pkgs, ... }:
    lib.mkMerge [
      (config.flake.lib.allowUnfree [ "discord" ])
      {
        home.packages = lib.mkDefault [
          (pkgs.discord.override {
            withOpenASAR = lib.mkDefault true;
            withVencord = lib.mkDefault true;
          })
        ];
      }
    ];
}
