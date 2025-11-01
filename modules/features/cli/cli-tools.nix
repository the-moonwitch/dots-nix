{ lib, ... }:
{
  flake.aspects.cli-tools.homeManager = { ... }: {
    programs = {
      # Better shell history
      atuin = {
        enable = lib.mkDefault true;
        flags = lib.mkDefault [ "--disable-up-arrow" ];
      };

      # Fast cd
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      zoxide.enable = lib.mkDefault true;

      # Fuzzy finder
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      fzf.enable = lib.mkDefault true;

      # Better cat
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      bat = {
        enable = lib.mkDefault true;
        config = {
          paging = lib.mkDefault "never";
        };
      };

      # Better ls
      # TODO: readme includes AI ads,
      # replace with something non-brainrotted
      eza.enable = lib.mkDefault true;

      # Better grep
      ripgrep.enable = lib.mkDefault true;
    };
  };
}
