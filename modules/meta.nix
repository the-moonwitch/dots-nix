{ inputs, ... }:
{
  imports = [ inputs.cadence.flakeModules.default ];

  flake-file = {
    description = "Ninix";
    inputs = {
      cadence.url = "github:the-moonwitch/cadence";
    };
  };
}
