{ lib, ... }:
{
  options.flake.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        hostname = lib.mkOption {
          type = lib.types.str;
          description = "System hostname";
        };

        system = lib.mkOption {
          type = lib.types.str;
          description = "System architecture (e.g., x86_64-linux, aarch64-darwin)";
        };

        class = lib.mkOption {
          type = lib.types.enum [ "nixos" "darwin" ];
          description = "System class (nixos or darwin)";
        };

        username = lib.mkOption {
          type = lib.types.str;
          description = "Primary user username";
        };

        aspects = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of aspects to include for this host";
        };
      };
    });
    default = {};
    description = "Host definitions";
  };
}
