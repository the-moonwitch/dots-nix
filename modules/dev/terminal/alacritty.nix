{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "alacritty" {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          dynamic_padding = true;
          decorations = "none";
        };
      };
    };
  };
}
