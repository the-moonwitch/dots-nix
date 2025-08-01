{
  flake.modules.homeManager.cli-utils =
    { ... }:
    {
      programs = {
        # Automatic environment management
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        # Better shell history
        atuin.enable = true;

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
        bat.enable = true;

        # Better ls
        # TODO: readme includes AI ads,
        # replace with something non-brainrotted
        eza.enable = true;

        # Better grep
        ripgrep.enable = true;
      };
    };
}
