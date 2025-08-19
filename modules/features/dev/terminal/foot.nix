{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "foot" {
    programs.foot = {
      enable = true;
    };
  };
}
