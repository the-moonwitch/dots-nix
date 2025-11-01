{
  config,
  lib,
  inputs,
  ...
}:
let
  # Build configuration for a host
  mkHostConfig =
    hostname: hostDef:
    let
      homeDir =
        if hostDef.class == "darwin" then "/Users/${hostDef.username}" else "/home/${hostDef.username}";

      # Get all modules for the requested aspects
      getModules =
        class:
        builtins.filter (x: x != null) (
          map (aspect: config.flake.modules.${class}.${aspect} or null) hostDef.aspects
        );

      homeModule = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit hostDef;
          };
          users.${hostDef.username} = {
            imports = getModules "homeManager";
            home = {
              username = hostDef.username;
              homeDirectory = homeDir;
            };
          };
        };
      };
    in
    if hostDef.class == "darwin" then
      inputs.nix-darwin.lib.darwinSystem {
        inherit (hostDef) system;
        specialArgs = {
          inherit hostDef;
        };
        modules = [
          inputs.home-manager.darwinModules.home-manager
          homeModule
          { nixpkgs.hostPlatform = hostDef.system; }
        ] ++ getModules "darwin";
      }
    else # nixos
      inputs.nixpkgs.lib.nixosSystem {
        inherit (hostDef) system;
        specialArgs = {
          inherit hostDef;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          homeModule
          {
            nixpkgs.hostPlatform = hostDef.system;
            networking.hostName = hostDef.hostname;
          }
        ] ++ getModules "nixos";
      };
in
{
  config.flake.darwinConfigurations = lib.mapAttrs' (
    name: hostDef: lib.nameValuePair hostDef.hostname (mkHostConfig name hostDef)
  ) (lib.filterAttrs (n: v: v.class == "darwin") config.flake.hosts);

  config.flake.nixosConfigurations = lib.mapAttrs' (
    name: hostDef: lib.nameValuePair hostDef.hostname (mkHostConfig name hostDef)
  ) (lib.filterAttrs (n: v: v.class == "nixos") config.flake.hosts);
}
