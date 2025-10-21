{ inputs, ... }:
{
  flake-file.inputs.nix-mdbook.url = "github:pbar1/nix-mdbook";

  perSystem =
    { system, ... }:
    {
      packages.doc = inputs.nix-mdbook.lib.buildMdBookProject {
        inherit system;
        src = ../doc;
      };
    };
}
