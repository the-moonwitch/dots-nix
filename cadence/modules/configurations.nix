{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (config) cadence;
  inherit (builtins)
    getAttr
    map
    ;
  inherit (cadence.lib) const;
  hosts = lib.mapAttrsToList (label: hostDef: {
    def = hostDef // {
      inherit label;
    };
    modules = config.cadence._hostModules.${label};
  }) cadence.hosts;

  configurations =
    {
      getKey, # host -> string
      class, # string
      getExtraArgs, # host -> attrset,
      mkSystem,
      getBaseModules, # listOf module
    }:
    builtins.foldl' lib.recursiveUpdate { } (
      map (
        { def, modules }:
        lib.optionalAttrs (def.class == class) {
          ${getKey def} = mkSystem (
            {
              modules = (getBaseModules def) ++ [
                {
                  imports = modules.${class};
                  home-manager.users.${def.username} = {
                    imports = modules.${const.class.homeManager};
                  };
                }
              ];
            }
            // (getExtraArgs def)
          );
        }
      ) hosts
    );

  nixosConfigurations = configurations {
    getKey = getAttr "hostname";
    class = const.class.nixos;
    getExtraArgs = def: {
      system = def.system;
      specialArgs.host = def;
    };
    mkSystem = inputs.nixpkgs.lib.nixosSystem;
    getBaseModules = def: [
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.hostPlatform = def.system;
        networking.hostName = def.hostname;
      }
    ];
  };

  darwinConfigurations = configurations {
    getKey = getAttr "hostname";
    class = const.class.darwin;
    getExtraArgs = def: {
      specialArgs.host = def;
    };
    mkSystem = inputs.nixpkgs.lib.darwinSystem;
    getBaseModules = def: [
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.hostPlatform = def.system;
      }
    ];
  };

  homeConfigurations = configurations {
    getKey = def: "${def.username}@${def.hostname}";
    class = const.class.homeManager;
    getExtraArgs = def: {
      extraSpecialArgs.host = def;
    };
    mkSystem = inputs.home-manager.lib.homeManagerConfiguration;
    getBaseModules = def: [
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.hostPlatform = def.system;
      }
    ];
  };
in
{
  flake.nixosConfigurations = nixosConfigurations;
  flake.darwinConfigurations = darwinConfigurations;
  flake.homeConfigurations = homeConfigurations;
}
