let
  cadence.dependencies = {
    "desktop" = [
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
