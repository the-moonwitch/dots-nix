{ ... }:
{
  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
      ];
    };
}
