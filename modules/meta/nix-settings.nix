{ ... }:
let
  nixConfig = {
    # accept-flake-config = true;
    # auto-optimise-store = true;
    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    # preallocate-contents = true;
  };
in
{
  flake-file = {
    description = "Ninix";
    inherit nixConfig;
  };

  flake.modules.nixos.nix-settings = {
    nix.settings = nixConfig // {
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
