{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "spotify" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ spotify ];
      };
    }
  );
}
