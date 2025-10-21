{ lib, inputs, ... }:
let
  const = import ./_const.nix;

  host = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        description = "The hostname of the machine";
        type = lib.types.str;
      };
      system = lib.mkOption {
        description = "The system type of the host";
        type = lib.types.enum (import inputs.systems);
        default = "x86_64-linux";
      };
      class = lib.mkOption {
        description = "The class of the host";
        type = lib.types.enum (builtins.attrValues const.class);
        default = "nixos";
      };
      features = lib.mkOption {
        description = "Features enabled on the host";
        type = lib.types.listOf (lib.types.str);
        default = [ ];
      };
      username = lib.mkOption {
        description = "Username of the primary user on this host";
        type = lib.types.str;
        default = "user";
      };
      extra = lib.mkOption {
        description = "Extra attributes for the host";
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };
    };
  };
in
{
  options.cadence = lib.mkOption {
    description = "Cadence configuration";
    type = lib.types.submodule {
      options = {
        dependencies = lib.mkOption {
          description = ''
            Dependencies for each feature; features belonging to each tag or group.
          '';
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          default = { };
          example = lib.literalExpression ''
            dependencies.group-desktop = [ "desktop-manager" "browser" ];
            dependencies.desktop-manager = [ "gnome" ];
            dependencies.gnome = [ "x11" ];
          '';
        };

        hosts = lib.mkOption {
          description = "Host configurations";
          type = lib.types.attrsOf host;
          default = { };
          example = lib.literalExpression ''
            cadence.hosts.my-host = {
              hostname = "my-host";
              system = "x86_64-linux";
              class = "nixos";
              features = [ "group-desktop" "vscode" "enable-ssh" ];
            };
          '';
        };
      };
    };
  };
}
