{ lib, config, ... }:
{
  flake.aspects.vscode.homeManager =
    { pkgs, ... }:
    lib.mkMerge [
      (config.flake.lib.allowUnfree [ "vscode" ])
      {
        programs.vscode = {
          enable = lib.mkDefault true;
        };
      }
    ];
}
