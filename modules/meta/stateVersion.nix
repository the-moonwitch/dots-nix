{ ... }:
{
  flake.modules =
    let
      stateVersion = "25.05";
    in
    {
      homeManager.base = {
        home = { inherit stateVersion; };
      };

      nixos.base = {
        system = {
          inherit stateVersion;
          rebuild.enableNg = true;
        };
      };
    };
}
