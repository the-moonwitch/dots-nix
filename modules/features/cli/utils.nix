{ inputs, ... }:
let
  inherit (inputs.cadence.lib.feature) homeManager;
  flake.modules = homeManager "cli-utils" {
    programs = {
      # Better shell history
      atuin = {
        enable = true;
        flags = [ "--disable-up-arrow" ];
      };

      # Fast cd
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      zoxide.enable = true;

      # Fuzzy finder
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      fzf.enable = true;

      # Better cat
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      bat = {
        enable = true;
        config = {
          paging = "never";
        };
      };

      # Better ls
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      eza.enable = true;

      # Better grep
      ripgrep.enable = true;
    };
  };
in
{
  inherit flake;
}
