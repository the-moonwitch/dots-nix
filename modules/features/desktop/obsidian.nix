{ lib, config, ... }:
{
  flake.aspects.obsidian.homeManager =
    { ... }:
    lib.mkMerge [
      (config.flake.lib.allowUnfree [ "obsidian" ])
      {
        programs.obsidian = {
          enable = lib.mkDefault true;
        };
      }
    ];
}
