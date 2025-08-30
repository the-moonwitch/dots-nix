{
  lib,
  inputs,
  ...
}:
let
  const = import ./_const.nix;
  constTrue = lib.const true;

  functionType = lib.mkOptionType {
    name = "function";
    check = f: builtins.isFunction f || (f ? __functor);
    emptyValue = constTrue;
  };
  targetDef =
    targetName:
    lib.mkOption {
      description = "The ${targetName} definition of the feature.";
      type = lib.types.deferredModule;
      default = { };
    };

  featureImpl = lib.types.submodule {
    options = {
      pred = lib.mkOption {
        description = ''
          Necessary precondition for the feature.
          Should be a function from a host key to bool, returning true if the feature
          can be enabled on that host.'';
        type = functionType;
        default = constTrue;
        defaultText = lib.literalExpression "lib.const true";
      };
      ${const.class.homeManager} = targetDef const.class.homeManager;
      ${const.class.nixos} = targetDef const.class.nixos;
      ${const.class.darwin} = targetDef const.class.darwin;
    };
  };

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
  config.cadence = {
    lib = {
      types = { inherit host featureImpl; };
      inherit const;
    };
  };

  options.cadence = lib.mkOption {
    description = "Cadence configuration";
    type = lib.types.submodule {
      options = {
        lib = lib.mkOption {
          description = "Cadence library";
          type = lib.types.attrsOf lib.types.anything;
          default = { };
        };

        features = lib.mkOption {
          description = "Feature definitions";
          type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf featureImpl);
          example = lib.literalExpression ''
            features.enable-ssh = {
              nixos = cadence.lib.nixosFeature.system {
                  services.openssh.enable = true;
                };
              };
            };
          '';
          default = { };
        };

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

        # Internals
        _hostModules = lib.mkOption {
          description = "Internal: canonical-form, resolved modules per host.";
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = lib.pipe const.class [
                builtins.attrValues
                (builtins.map (class: {
                  name = class;
                  value = lib.mkOption {
                    type = lib.types.listOf lib.types.deferredModule;
                    default = [ ];
                  };
                }))
                builtins.listToAttrs
              ];
            }
          );
          default = { };
        };
      };
    };
  };
}
