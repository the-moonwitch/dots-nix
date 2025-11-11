{ lib, ... }:
{
  flake.aspects.iterm2.darwin = { ... }: {
    homebrew.casks = lib.mkDefault [ "iterm2" ];
  };
}
