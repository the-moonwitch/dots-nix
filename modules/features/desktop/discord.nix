{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "discord" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          (discord.override {
            withOpenASAR = true;
            withVencord = true;
          })
        ];
      };
    }
  );
in
{
  inherit flake;
}
