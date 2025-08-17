{ inputs, ... }:
let
  homeManagerConfiguration = inputs.home-manager.lib.homeManagerConfiguration;
  hmModules = inputs.self.modules.homeManager;
  nixosModules = inputs.self.modules.nixos;
  homeConfiguration =
    {
      hostname,
      modules ? [ ],
      ...
    }:
    homeManagerConfiguration {
      pkgs = inputs.self.nixosConfigurations.${hostname}.pkgs;
      modules = [
        # hmModules.base
        hmModules.${hostname}
      ] ++ modules;
    };
  nixosConfiguration =
    {
      hostname,
      system ? "x86_64-linux",
      modules ? [ ],
      ...
    }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        { nixpkgs.hostPlatform = system; }

        # nixosModules.base
        nixosModules.${hostname}
        # (nixosModules.${hostname} or { } )
      ] ++ modules;
    };
in
{
  flake.lib = { inherit homeConfiguration nixosConfiguration; };
}
