{ inputs, ... }:
{
  imports = [ inputs.cadence.flakeModules.default ];

  flake-file = {
    description = "Ninix";
    inputs = {
      cadence.url = "path:/home/ines/dots/cadence";
    };
  };
}
