{ inputs, lib, ... }:
let
  hostsList = builtins.map (def: {
    class = def.class;
    name = def.hostname;
    value = inputs.self.lib.mkHost def;
  }) (builtins.attrValues inputs.self.hosts);
  byClass = builtins.partition (host: host.class == "nixos") hostsList;
  configurations = hosts: lib.mergeAttrsList (builtins.map (l: l.value) hosts);
  nixosConfigurations = configurations byClass.right;
  darwinConfigurations = configurations byClass.wrong;
in
{
  flake.nixosConfigurations = nixosConfigurations;
  flake.darwinConfigurations = darwinConfigurations;
}
