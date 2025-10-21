{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) homeManager darwin;
  flake.modules = features [
    (darwin "MAC-QXGYWVX" {
      homebrew = {
        brews = [
          "rustup"
          "protobuf"
          "pipx"
          "uv"
        ];
        casks = [
          "firefox"
          "spotify"
        ];
      };
    })
    (homeManager "MAC-QXGYWVX" (
      { pkgs, ... }:
      {

        services.ssh-agent.enable = !(pkgs.stdenvNoCC.isDarwin);
        programs.fish.shellInit = ''
          fish_add_path $(brew --prefix rustup)/bin
        '';
        programs.ssh = {
          enable = true;
          addKeysToAgent = "yes";
          extraConfig = ''
            Host *
              IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          '';
        };
      }))
  ];
in
{
  inherit flake;
}