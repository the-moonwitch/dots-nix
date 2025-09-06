{ inputs, ... }:
{
  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  imports = [
    {
      flake.modules = inputs.self.lib.mkFeature "secrets" {
        nixos = {
          imports = [ inputs.opnix.nixosModules.default ];
          # services.onepassword-secrets = {
          #   enable = true;
          # };
        };
        darwin = {
          imports = [ inputs.opnix.darwinModules.default ];
          # services.onepassword-secrets = {
          #   enable = true;
          # };
        };
        home = {
          programs.gpg = {
            enable = true;
          };
        };
      };
    }

    {
      flake.modules = inputs.self.lib.mkFeature "opass-gui" {
        darwin = {
          homebrew.casks = [ "1password" ];
        };
      };
    }
  ];
}
