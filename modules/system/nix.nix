{ lib, inputs, ... }:
{
  flake-file = {
    nixConfig = {
      extra-experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
    inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  };

  flake.aspects."system/nix" = {
    nixos =
      { pkgs, hostDef, config, ... }:
      {
        nixpkgs.overlays = lib.mkDefault [ (_final: prev: { nix = prev.lix; }) ];
        nix.package = lib.mkDefault pkgs.lix;

        programs.command-not-found.enable = lib.mkDefault true;
        nixpkgs = {
          hostPlatform = lib.mkDefault hostDef.system;
        };

        services.onepassword-secrets.secrets.nixAccessTokens = lib.mkDefault {
          reference = "op://Host Secrets/Nix Access Tokens/credential";
          group = "onepassword-secrets";
          mode = "0640";
        };

        nix.settings = {
          experimental-features = lib.mkDefault [
            "flakes"
            "nix-command"
          ];
          extra-experimental-features = lib.mkDefault [
            "flakes"
            "nix-command"
          ];
          trusted-users = lib.mkDefault [
            "root"
            "@wheel"
            hostDef.username
          ];
        };
        nix.extraOptions = lib.mkDefault ''
          !include ${config.services.onepassword-secrets.secretPaths.nixAccessTokens}
        '';
      };

    darwin =
      { pkgs, hostDef, config, ... }:
      {
        nixpkgs.overlays = lib.mkDefault [ (_final: prev: { nix = prev.lix; }) ];
        nix.package = lib.mkDefault pkgs.lix;

        nixpkgs = {
          hostPlatform = lib.mkDefault hostDef.system;
        };

        services.onepassword-secrets.secrets.nixAccessTokens = lib.mkDefault {
          reference = "op://Host Secrets/Nix Access Tokens/credential";
          group = "onepassword-secrets";
          mode = "0640";
        };

        nix.settings = {
          experimental-features = lib.mkDefault [
            "flakes"
            "nix-command"
          ];
          extra-experimental-features = lib.mkDefault [
            "flakes"
            "nix-command"
          ];
          trusted-users = lib.mkDefault [
            "root"
            "@admin"
            hostDef.username
          ];
        };
        nix.extraOptions = lib.mkDefault ''
          !include ${config.services.onepassword-secrets.secretPaths.nixAccessTokens}
        '';
      };

    homeManager = { ... }: {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      programs = {
        nix-index.enable = lib.mkDefault true;
        nix-index-database.comma.enable = lib.mkDefault true;

        nh = {
          enable = lib.mkDefault true;
          # nh will auto-detect the flake location
        };
      };
    };
  };
}
