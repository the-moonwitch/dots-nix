{ lib, inputs, ... }:
{
  flake.lib = {
    # Helper to allow specific unfree packages
    # Usage: nixpkgs.config.allowUnfreePredicate = config.flake.lib.allowUnfree ["discord"];
    allowUnfree = pkgs: pkg: builtins.elem (lib.getName pkg) pkgs;

    # Helper to import multiple aspects across all module classes
    # Usage: flake.aspects.base = modules ["system/base" "system/nix" "system/state-version"];
    modules = aspects: {
      nixos = { ... }: {
        imports = builtins.filter (x: x != null) (
          map (aspect: inputs.self.modules.nixos.${aspect} or null) aspects
        );
      };
      darwin = { ... }: {
        imports = builtins.filter (x: x != null) (
          map (aspect: inputs.self.modules.darwin.${aspect} or null) aspects
        );
      };
      homeManager = { ... }: {
        imports = builtins.filter (x: x != null) (
          map (aspect: inputs.self.modules.homeManager.${aspect} or null) aspects
        );
      };
    };
  };
}
