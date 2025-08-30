{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    programs = {
      # Nix
      nixfmt = {
        enable = true;
        strict = true;
        width = 79;
      };
      deadnix.enable = true;
      nixf-diagnose.enable = true;
      # Shell
      beautysh.enable = true;
      shellcheck.enable = true;
      fish_indent.enable = true;
      # Web
      prettier.enable = true;
      # Cfg
      toml-sort.enable = true;
    };
    settings = {
      # TODO:
      #  Flake.nix gets formatted using different settings at generation,
      #  which makes the equality check fail.
      # Figure out a way to match the formatter settings used by `nixfmt` vs
      # `#write-flake`.
      global.excludes = [
        "flake.lock"
        "flake.nix"
      ];
      # formatter.toml-sort.includes = [ "*.toml" ];
      on-unmatched = "warn";
    };
  };

}
