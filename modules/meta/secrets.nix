{ inputs, ... }:
{
  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  flake.modules.nixos.secrets = {
    imports = [ inputs.opnix.nixosModules.default ];
  };

  flake.modules.darwin.secrets = {
    imports = [ inputs.opnix.darwinModules.default ];
  };

  flake.modules.homeManager.secrets = {
    imports = [ inputs.opnix.homeManagerModules.default ];
  };
}
