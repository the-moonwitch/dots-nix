{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "vscode" (
    { ... }:
    {
      programs = {
        vscode = {
          enable = true;
        };
      };
    }
  );
}
