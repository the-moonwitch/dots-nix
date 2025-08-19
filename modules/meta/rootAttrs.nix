{ inputs, lib, ... }:
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

    hosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hostname = lib.mkOption { type = lib.types.str; };
            system = lib.mkOption {
              type = lib.types.str;
              default = "x86_64-linux";
            };
            class = lib.mkOption {
              type = lib.types.str;
              default = "nixos";
            };
            username = lib.mkOption {
              type = lib.types.str;
              default = inputs.self.const.me.username;
            };
            features = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
          };
        }
      );
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
