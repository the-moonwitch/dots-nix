let
  cadence.dependencies = {
    "desktop" = [
      "browser[firefox]"
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
