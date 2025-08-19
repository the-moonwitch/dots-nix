{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "telegram" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ telegram-desktop ];
      };
    }
  );
}
