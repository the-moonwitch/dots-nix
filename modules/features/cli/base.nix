{ ... }:
let
  cadence.dependencies = {
    cli = [
      "git"
      "fish"
      "fish[default]"
    ];
  };
in
{
  inherit cadence;
}
