{
  flake.modules.homeManager.alacritty = {
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
