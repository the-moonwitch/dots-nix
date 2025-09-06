let
  cadence.dependencies = {
    "desktop" = [ ];
    "desktop[personal]" = [
      "desktop"
      "browser[firefox]"
      "discord"
      "telegram"
      "spotify"
    ];
  };
in
{
  inherit cadence;
}
