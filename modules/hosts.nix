{ inputs, self, ... }:
let
  inherit (self.lib) hosts;
in
{
  cadence.hosts = hosts {
    moth = { };
  };
}
