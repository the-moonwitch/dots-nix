/**
  Personal desktop machines, i.e. including non-work-relevant software.
*/
{ ... }:
{
  flake.dependencies.preset-desktop-personal = [
    "preset-desktop"
    "discord"
  ];
}
