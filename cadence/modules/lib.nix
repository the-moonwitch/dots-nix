{
  config,
  lib,
  ...
}:
let
  const = import ./_const.nix;
in
{
  config.cadence.lib =
    let
      hostDef = label: config.cadence.hosts.${label} // { inherit label; };

      classFeature =
        class:
        let
          mkClassFeature =
            {
              system ? { },
              homeManager ? { },
            }:
            {
              inherit homeManager;
              pred = h: h.class == class;
              ${class} = system;
            };
        in
        {
          system = mod: mkClassFeature { system = mod; };
          homeManager = mod: mkClassFeature { homeManager = mod; };
          __functor = _: mkClassFeature;
        };
      /**
        Define a feature that will only apply to a specific host.

        # Example

        ```nix
        features.hetznerSetup.def = (hostFeature "hetzner-vps").homeManager {
          programs.fish.enable = true;
        };
        ```

        # Type

        ```
        hostFeature :: string -> module -> cadence.lib.types.featureImpl;
        ```

        # Arguments

        hostKey
        : The key of the host definition in `hosts`

        mod
        : The module definition to use for the host.
      */

      # TODO fix doc for functors
      hostFeature =
        hostLabel:
        let
          def = hostDef hostLabel;
          notSystemErr = "Host ${hostLabel} is not a system host but tried to call `hostFeature.system \"${hostLabel}\"`";
          pred = h: h.label == hostLabel;
          systemKey = if def.class == "home-manager" then null else def.class;
        in
        {
          system =
            mod:
            if systemKey == null then
              throw notSystemErr
            else
              {
                inherit pred;
                ${systemKey} = mod;
              };
          homeManager = homeManager: {
            inherit pred homeManager;
          };
          __functor =
            _:
            {
              system ? { },
              homeManager ? { },
            }:
            {
              inherit homeManager pred;
              ${if systemKey == null && system != { } then throw notSystemErr else systemKey} = system;
            };
        };
      nixosFeature = classFeature "nixos";
      darwinFeature = classFeature "darwin";
      systemFeature = mod: {
        pred = h: h.class != const.class.homeManager;
        ${const.class.darwin} = mod;
        ${const.class.nixos} = mod;
      };
      homeFeature = mod: {
        pred = h: h.class == const.class.homeManager;
        ${const.class.homeManager} = mod;
      };
    in
    {
      inherit
        hostDef
        nixosFeature
        darwinFeature
        homeFeature
        hostFeature
        systemFeature
        ;
    };

}
