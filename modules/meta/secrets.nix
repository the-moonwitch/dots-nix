{ lib, inputs, ... }:
{
  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  flake.modules.nixos.secrets = {
    imports = [ inputs.opnix.nixosModules.default ];
    # services.onepassword-secrets.enable = lib.mkForce true; 
  };

  flake.modules.darwin.secrets = {
    imports = [ inputs.opnix.darwinModules.default ];
# services.onepassword-secrets.enable = lib.mkForce true;
  };

  flake.modules.homeManager.secrets = {
    imports = [ inputs.opnix.homeManagerModules.default ];
# programs.onepassword-secrets = lib.mkForce true;
  };
}
