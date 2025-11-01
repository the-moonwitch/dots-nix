{ config, ... }:
{
  # Base preset includes essential system features
  flake.aspects.base = config.flake.lib.modules [
    "system/base"
    "system/nix"
    "system/state-version"
    "system/secrets"
    "system/theming"
  ];
}
