{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # Disable automatic cachix cache management
  cachix.enable = false;

  # https://devenv.sh/packages/
  packages = with pkgs; [ git nh ];

  # https://devenv.sh/languages/
  languages.nix.enable = true;

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    # Helper to get the appropriate nh subcommand for the current platform
    nh-platform.exec = ''
      if [ -f /etc/NIXOS ]; then
        echo "os"
      else
        echo "darwin"
      fi
    '';

    # Switch to new configuration
    switch.exec = ''
      if ! [ -f /etc/opnix-token ] && command -v opnix >/dev/null 2>&1; then
        sudo opnix token set
      fi
      nh "$(nh-platform)" switch . -- "$@"
    '';

    # Build configuration without switching
    build.exec = ''
      nh "$(nh-platform)" build . -- "$@"
    '';

    # Update flake inputs
    update.exec = ''
      nix flake update "$@"
    '';

    # Check flake validity
    check.exec = ''
      nix flake check "$@"
    '';

    # Clean old generations (keep last 5)
    clean.exec = ''
      nh clean all --keep 5 "$@"
    '';
  };

  # https://devenv.sh/basics/
  enterShell = ''
    echo "Welcome to the devenv shell!"
    echo "Available commands: switch, build, update, check, clean"
    git --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}