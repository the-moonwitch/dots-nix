{ inputs, ... }:
let
  inherit (inputs.cadence.lib) feature features;
  inherit (feature) homeManager;

  flake-file.inputs = {
    opnix.url = "github:brizzbuzz/opnix";
  };

  flake.modules = features [
    (homeManager "git" (
      { pkgs, host, ... }:
      {
        home.packages = [ pkgs.difftastic ];

        programs.gh = {
          enable = true;
          gitCredentialHelper.enable = true;
          extensions = [ pkgs.gh-copilot ];
        };

        programs.git = {
          enable = !pkgs.stdenvNoCC.isDarwin;
          package = pkgs.gitFull;
          settings = {
            user = {
              name = host.extra.signature or "ines";
              email = host.extra.email or "ines@moonwit.ch";
            };
            init.defaultBranch = "main";
            pager.difftool = true;
            github.user = "the-moonwitch";
            core.editor = "nvim";
            branch.autosetuprebase = "always";
            diff.mnemonicprefix = true;
            color = {
              ui = "auto";
            };
            push = {
              autoSetupRemote = true;
              default = "current";
            };
            pull = {
              default = "matching";
              rebase = true;
            };
            rebase = {
              instructionFormat = "(%an <%ae>) %s";
              updateRefs = true;
              abbreviateCommands = true;
            };
            rerere = {
              enabled = true;
            };
          };
          signing = {
            format = "ssh";
            # signByDefault = true;
          };
          extraConfig = { };

          ignores = [
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
          includes = [ ];
          # { path = "${DOTS}/git/something"; }

          lfs.enable = true;

          #delta = {
          #  enable = true;
          #  options = {
          #    line-numbers = true;
          #    side-by-side = false;
          #  };
          #};
        };

        programs.difftastic = {
          enable = true;
          git.enable = true;
        };
      }
    ))

    (homeManager "jujutsu" (
      { host, ... }:
      {
        programs.jujutsu = {
          enable = true;
          settings = {
            user = {
              name = host.extra.signature or "Ines";
              email = host.extra.email or "ines@moonwit.ch";
            };
          };
        };
      }
    ))
  ];
in
{
  inherit flake flake-file;
}
