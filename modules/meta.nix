{ inputs, ... }:
{
  imports = [
    inputs.flake-aspects.flakeModule
    inputs.flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = "Ninix";
  };
}
