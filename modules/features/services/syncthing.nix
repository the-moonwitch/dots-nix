{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;

  flake.modules = (
    homeManager "syncthing" (
      { ... }:
      {
        services.syncthing = {
          enable = true;
          tray.enable = true;
          overrideFolders = true;
          overrideDevices = true;
          extraOptions = [ "--no-default-folder" ];

          # TODO
          #
          # devices = {
          #   <devname> = {
          #     id = "xyz";
          #     name = "name";
          #   }
          # }
          #
          # folders = {
          #   <path> = {
          #     id = "xyz";
          #     devices = [ "devname" ];
          #   }
          # }
        };
      }
    )
  );
in
{
  inherit flake;
}
