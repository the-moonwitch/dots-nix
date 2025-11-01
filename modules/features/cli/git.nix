{ lib, ... }:
{
  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  flake.aspects.git.homeManager =
    { pkgs, hostDef, ... }:
    {
      home.packages = [ pkgs.difftastic ];

      programs.gh = {
        enable = lib.mkDefault true;
        gitCredentialHelper.enable = lib.mkDefault true;
        extensions = lib.mkDefault [ pkgs.gh-copilot ];
      };

      programs.git = {
        enable = lib.mkDefault (!pkgs.stdenvNoCC.isDarwin);
        package = lib.mkDefault pkgs.gitFull;
        settings = {
          user = {
            name = lib.mkDefault "ines";
            email = lib.mkDefault "ines@moonwit.ch";
          };
          init.defaultBranch = lib.mkDefault "main";
          pager.difftool = lib.mkDefault true;
          github.user = lib.mkDefault "the-moonwitch";
          core.editor = lib.mkDefault "nvim";
          branch.autosetuprebase = lib.mkDefault "always";
          diff.mnemonicprefix = lib.mkDefault true;
          color = {
            ui = lib.mkDefault "auto";
          };
          push = {
            autoSetupRemote = lib.mkDefault true;
            default = lib.mkDefault "current";
          };
          pull = {
            default = lib.mkDefault "matching";
            rebase = lib.mkDefault true;
          };
          rebase = {
            instructionFormat = lib.mkDefault "(%an <%ae>) %s";
            updateRefs = lib.mkDefault true;
            abbreviateCommands = lib.mkDefault true;
          };
          rerere = {
            enabled = lib.mkDefault true;
          };
          signing = {
            signByDefault = lib.mkDefault false;
            key = lib.mkDefault null;
          };
        };

        ignores = lib.mkDefault [
          ".DS_Store"
          "*~"
          # Python
          "*.py[cod]"
          # TODO: maybe see if this *could* be versioned?
          ".idea"
          "__pycache__"
          # Tools
          # TODO: move this into a separate wakatime module eventually
          ".wakatime-project"
          # Nix
          "result"
        ];
        includes = lib.mkDefault [ ];
        # { path = "${DOTS}/git/something"; }

        lfs.enable = lib.mkDefault true;

        #delta = {
        #  enable = true;
        #  options = {
        #    line-numbers = true;
        #    side-by-side = false;
        #  };
        #};
      };

      programs.difftastic = {
        enable = lib.mkDefault true;
      };
    };
}
