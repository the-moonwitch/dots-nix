/**
  Personal desktop machines, i.e. including non-work-relevant software.
*/
{ inputs, ... }:
{
  flake.modules.homeManager.preset-personal-desktop = {
    imports = with inputs.self.modules.homeManager; [
      preset-desktop
      discord
    ];
  };
}
