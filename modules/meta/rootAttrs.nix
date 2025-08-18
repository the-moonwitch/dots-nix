{ lib, ... }:
{
  options.flake = {
    lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };

    dependencies = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
    };

    const.me = {
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
  };

  config.flake.const.me = {
    username = "ines";
    signature = "ines";
    email = "ines@moonwit.ch";
    authorizedKeys = [ ];
  };
}
