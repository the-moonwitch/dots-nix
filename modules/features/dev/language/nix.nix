{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "dev-nix" (
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ nil ];
      };
    }
  );
}
