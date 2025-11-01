{ lib, inputs, ... }:
let
  secrets = { };
in
{
  flake-file.inputs.opnix.url = "github:brizzbuzz/opnix";

  flake.aspects."system/secrets" = {
    nixos =
      { hostDef, ... }:
      {
        imports = [ inputs.opnix.nixosModules.default ];

        environment.systemPackages = lib.mkDefault [ inputs.opnix.packages.${hostDef.system}.default ];

        users.users."${hostDef.username}" = {
          extraGroups = lib.mkDefault [ "onepassword-secrets" ];
        };

        services.onepassword-secrets = {
          enable = lib.mkDefault true;
          users = lib.mkDefault [ hostDef.username ];
          inherit secrets;
          systemdIntegration = {
            enable = lib.mkDefault true;
            services = lib.mkDefault [ "home-manager-${hostDef.username}" ];
            restartOnChange = lib.mkDefault true;
            changeDetection.enable = lib.mkDefault true;
            errorHandling.rollbackOnFailure = lib.mkDefault true;
          };
        };
        programs._1password-gui.enable = lib.mkDefault true;
      };

    darwin = { ... }: {
      imports = [ inputs.opnix.darwinModules.default ];
      services.onepassword-secrets = {
        enable = lib.mkDefault true;
        inherit secrets;
      };
      homebrew.casks = lib.mkDefault [ "1password" ];
    };

    homeManager =
      { hostDef, ... }:
      {
        imports = [ inputs.opnix.homeManagerModules.default ];

        home.packages = lib.mkDefault [ inputs.opnix.packages.${hostDef.system}.default ];

        programs.gpg = {
          enable = lib.mkDefault true;
        };
      };
  };
}
