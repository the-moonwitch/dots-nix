{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "discord" (
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
}
