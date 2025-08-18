{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "jetbrains" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ jetbrains-toolbox ];
      };
    }
  );
}
