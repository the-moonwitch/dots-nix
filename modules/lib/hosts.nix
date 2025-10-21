{
  flake.lib.hosts =
    let
      common = {
        system = "x86_64-linux";
        class = "nixos";
        username = "ines";
        features = [ ];
        extra = {
          signature = "Ines";
          email = "ines@moonwit.ch";
          authorizedKeys = [ ];
        };
      };
      host = attrOverrides: common // attrOverrides;
    in
    {
      inherit common host;
      __functor =
        _: hostDefs:
        builtins.mapAttrs (name: def: { hostname = name; } // (host def)) hostDefs;
    };
}
