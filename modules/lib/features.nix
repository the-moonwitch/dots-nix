{ inputs, lib, ... }:
{
  flake.lib =
    let
      mkFeature =
        name:
        {
          nixos ? { },
          home ? { },
          darwin ? { },
        }:
        {
          nixos.${name} = nixos;
          homeManager.${name} = home;
          darwin.${name} = darwin;
        };
      mkNixosFeature = name: nixos: mkFeature name { inherit nixos; };
      mkHomeFeature = name: home: mkFeature name { inherit home; };
      mkDarwinFeature = name: darwin: mkFeature name { inherit darwin; };
      mkOSAgnosticFeature =
        name: mod:
        mkFeature name {
          nixos = mod;
          darwin = mod;
        };
      mkHost =
        {
          hostname,
          class ? "nixos",
          system ? "x86_64-linux",
          username ? inputs.self.const.me.username,
          features ? [ ],
          ...
        }:
        let
          requiredFeatures =
            let
              startSet = [
                "base"
                hostname
              ]
              ++ features;
              allFeatures = (
                inputs.self.dependencies
                // inputs.self.modules.nixos
                // inputs.self.modules.homeManager
                // inputs.self.modules.darwin
              );
              toKey =
                f:
                assert
                  builtins.hasAttr f (allFeatures // { ${hostname} = { }; })
                  || throw ''
                    Unknown feature: ${f}
                    Known features: ${builtins.concatStringsSep ", " (builtins.attrNames allFeatures)}
                  '';
                {
                  key = f;
                };

              keys = builtins.genericClosure {
                startSet = builtins.map toKey startSet;
                operator =
                  item: builtins.map toKey (inputs.self.dependencies.${item.key} or [ ]);
              };
              featuresWithDependencies = builtins.map (f: f.key) keys;
            in
            lib.unique featuresWithDependencies;
          modulesFor =
            moduleType:
            builtins.filter (f: f != null) (
              builtins.map (
                f: inputs.self.modules.${moduleType}.${f} or null
              ) requiredFeatures
            );
          homeModule = {
            home-manager.users.${username} = {
              imports = modulesFor "homeManager";
            };
          };

          nixosConfig = inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              {
                nixpkgs.hostPlatform = system;
                networking.hostName = hostname;
              }
              homeModule
            ]
            ++ modulesFor "nixos";
          };
          darwinConfig = inputs.nix-darwin.lib.darwinSystem {
            inherit system;
            modules = [ homeModule ] ++ modulesFor "darwin";
          };
        in
        {
          "${hostname}" = if class == "nixos" then nixosConfig else darwinConfig;
        };
    in
    {
      inherit
        mkFeature
        mkNixosFeature
        mkHomeFeature
        mkDarwinFeature
        mkOSAgnosticFeature
        mkHost
        ;
    };
}
