{ lib, ... }:
{
  options.flake.const.me = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "ines";
    };
    signature = lib.mkOption {
      type = lib.types.str;
      default = "ines";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "ines@moonwit.ch";
    };
    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config.flake.const.me = {
    username = "ines";
    signature = "ines";
    email = "ines@moonwit.ch";
    authorizedKeys = [ ];
  };
}
