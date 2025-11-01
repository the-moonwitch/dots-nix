{ lib, ... }:
{
  flake.aspects.fastfetch.homeManager = { lib, ... }: {
    programs.fastfetch = {
      enable = lib.mkDefault true;
      settings =
        let
          hlColor = "bold_magenta";
          pad =
            str:
            let
              width = 8;
              len = builtins.stringLength str;
            in
            if len < width then (lib.strings.replicate (width - len) " ") + str else str;
          padded = str: {
            type = str;
            key = pad str;
          };
        in
        lib.mkDefault {
          logo = {
            type = "small";
            padding.top = 4;
          };
          display = {
            separator = " ∷ ";
            color.separator = hlColor;
          };
          modules = [
            {
              type = "title";
              format = "    {user-name-colored} {at-symbol-colored} {host-name-colored}";
              color.user = hlColor;
              color.host = hlColor;
            }
            (padded "uptime")
            {
              type = "custom";
              format = "        ╶═╴";
              outputColor = hlColor;
            }
            {
              type = "os";
              key = pad "system";
            }
            (padded "kernel")
            (padded "host")
            {
              type = "packages";
              key = pad "pkg";
            }
            {
              type = "shell";
              key = pad "sh";
            }
            {
              type = "cpu";
              key = pad "cpu";
              temp = true;
              showPeCoreCount = true;
            }
            {
              type = "gpu";
              key = pad "gpu";
              driverSpecific = true;
              temp = true;
            }
            {
              type = "disk";
              key = pad "disk";
              folders = [ "/" ];
            }
            (padded "memory")
          ];
        };
    };
  };
}
