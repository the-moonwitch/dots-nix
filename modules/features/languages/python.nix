{ lib, ... }:
{
  flake.aspects.python.homeManager = { ... }: {
    programs.uv.enable = lib.mkDefault true;
    programs.fish.shellInit = lib.mkDefault ''
      uv python install --preview-features python-install-default --default > /dev/null 2>&1 || true
    '';
  };
}
