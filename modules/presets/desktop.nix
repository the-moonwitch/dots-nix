{ ... }:
{
  flake.dependencies."preset/desktop" = [
    "audio"
    "desktop"
    "browser"
  ];

  flake.dependencies."preset/desktop/personal" = [
    "preset/desktop"
    "discord"
    "telegram"
  ];
}
