{ ... }:
let
  cadence.dependencies = {
    cli = [ "git" ];
  };
in
{
  inherit cadence;
}
