{ inputs, ... }:
{
  flake.modules = inputs.self.lib.mkHomeFeature "vscode" 
      ({ pkgs, ... }: {
    home =
      {
        packages = with pkgs; [ nil ];
      };

    programs = {
      vscode = {
        enable = true;
      };
    };
  });
}
