{ lib, ... }:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  # options.flake.const = lib.mkOption {
  #   type = lib.types.attrsOf lib.types.unspecified;
  #   default = { };
  # };
}
