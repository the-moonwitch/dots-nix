{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) nixos darwin homeManager;
  secrets = {

  };

  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  flake.modules = features [
    (nixos "secrets" (
      { host, ... }:
      {
        imports = [ inputs.opnix.nixosModules.default ];

        environment.systemPackages = [ inputs.opnix.packages.${host.system}.default ];

        users.users."${host.username}" = {
          extraGroups = [ "onepassword-secrets" ];
        };

        services.onepassword-secrets = {
          enable = true;
          users = [ host.username ];
          inherit secrets;
          systemdIntegration = {
            enable = true;
            services = [ "home-manager-${host.username}" ];
            restartOnChange = true;
            changeDetection.enable = true;
            errorHandling.rollbackOnFailure = true;
          };
        };
        programs._1password-gui.enable = true;
      }
    ))

    (darwin "secrets" {
      imports = [ inputs.opnix.darwinModules.default ];
      services.onepassword-secrets = {
        enable = true;
        inherit secrets;
      };
    })

    (homeManager "secrets" (
      { host, ... }:
      {
        imports = [ inputs.opnix.homeManagerModules.default ];

        home.packages = [ inputs.opnix.packages.${host.system}.default ];

        programs.onepassword-secrets = {
          # enable = true;
        };

        programs.gpg = {
          enable = true;
        };
      }
    ))

    (darwin "opass-gui" { homebrew.casks = [ "1password" ]; })
  ];
in
{
  inherit flake flake-file;
}
