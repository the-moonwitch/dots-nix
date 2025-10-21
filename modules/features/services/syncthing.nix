{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) nixos;
  devices = rec {
    personal = {
      dawn = {
        id = "D2I6IKX-NQZ2OHW-672NXVO-XK6LR2B-MBQYRLT-Q4W3MGU-ZVUEGEH-TFBFQQH";
        name = "dawn";
      };
      inanna = {
        id = "3LRSEZT-2DZUN33-FZY3WZH-CWN4764-4VCUM3L-MFT2LKC-MITH7WF-SR5FJAK";
        name = "inanna";
      };
      hecate = {
        id = "7RP4R6Z-SDH2OLY-IUKCFIV-ODGVCCR-LAMYPNU-2F2664V-PCESF3A-FOAUDAW";
        name = "hecate";
      };
    };
    czosnekspace = {
      czosntop = {
        id = "257OUUC-BNQ4DLU-HECAQEH-JEGCOME-UPHOH2J-D44OJP4-5FVBVBF-X2WOLQ4";
        name = "czosntop";
      };
      utena = {
        id = "S3S2ZKT-VUAY2PV-FI7DBIT-Q5BZDWN-G6HYZHT-FFRLMFR-6ZQVF5V-M6LNPAI";
        name = "utena";
      };
      czosnphone = {
        id = "RZ2VBAY-5VXOWK2-DKNP3ZM-4HSI7LN-E62O4Q5-OOXXNBE-375NLFR-TSMCPAY";
        name = "czosnphone";
      };
    };
    doll = {
      homutorola = {
        id = "KCSW3EU-S4UZXL7-5GRK5CJ-53YGDIN-NDHER6V-3MQFPEQ-2YZ7DPY-A4FKPQG";
        name = "homutorola";
      };
    };
    groups = {
      personal = personal;
      czosnekspace = (czosnekspace // personal);
      doll = (personal // doll);
      all = (personal // czosnekspace // doll);
    };
  };

  flake.modules = (
    nixos "syncthing" (
      {
        config,
        host,
        home,
        ...
      }:
      let
        dataDir = "${home}/Sync";
        versioning = {
          type = "staggered";
          fsPath = "${dataDir}/.stversions";
          params = {
            cleanupInterval = "3600";
            maxAge = "31536000";
          };
        };
      in
      {
        services.onepassword-secrets = {
          secrets = {
            syncthingCert.reference = "op://Host Secrets/Syncthing.${host.hostname}/cert.pem";
            syncthingKey.reference = "op://Host Secrets/Syncthing.${host.hostname}/key.pem";
          };
          systemdIntegration.services = [ "syncthing" ];
        };

        systemd.services.syncthing.restartIfChanged = true;
        services.syncthing = {
          enable = true;

          openDefaultPorts = true;
          user = host.username;
          group = host.username;
          dataDir = dataDir;
          configDir = "${home}/.config/syncthing";
          key = config.services.onepassword-secrets.secretPaths.syncthingKey;
          cert = config.services.onepassword-secrets.secretPaths.syncthingCert;

          settings = {
            options.urAccepted = -1;
            devices = devices.groups.all;

            defaults.folder = {
              path = dataDir;
              inherit versioning;
            };

            folders = {
              czosnekspace = {
                id = "czosnekspace";
                label = "Czosnekspace";
                path = "${dataDir}/Czosnekspace";
                inherit versioning;
                devices = builtins.attrNames devices.groups.czosnekspace;
              };
              grimoire = {
                id = "caccd-tqbvy";
                label = "Grimoire";
                path = "${dataDir}/Grimoire";
                inherit versioning;
                devices = builtins.attrNames devices.groups.personal;
              };
              bunny = {
                id = "bunny-binkie";
                label = "Bunny";
                path = "${dataDir}/Bunny";
                inherit versioning;
                devices = builtins.attrNames devices.groups.doll;
              };
            };
          };
        };
      }
    )
  );
in
{
  inherit flake;
}
