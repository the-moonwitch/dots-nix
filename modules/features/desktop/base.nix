let
  cadence.dependencies = {
    "desktop" = [
      "browser[firefox]"
      "browser[zen]"
      "spotify"
    ];
    "desktop[personal]" = [
      "desktop"
      "discord"
      "telegram"
      "obsidian"
      "syncthing"
    ];
  };
in
{
  inherit cadence;
}
