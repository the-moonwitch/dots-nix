{ config, ... }:
{
  # CLI preset includes shell and common CLI tools
  flake.aspects.cli = config.flake.lib.modules [
    "fish"
    "starship"
    "cli-tools"
    "fastfetch"
    "git"
  ];
}
