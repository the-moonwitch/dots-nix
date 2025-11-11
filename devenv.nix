{ pkgs, ... }:
{
  packages = with pkgs; [ nh ];

  scripts = {
    fmt.exec = ''
      nix fmt
      nix fmt
    '';

    update-deps.exec = ''
      nix flake update "$@"
    '';

    write-flake.exec = ''
      nix run ".#write-flake" "$@"
    '';

    update-flake.exec = ''
      update-deps "$@"
      write-flake "$@"
    '';

    build.exec = ''
      write-flake "$@"
      nh os build . -- "$@"
    '';

    switch.exec = ''
      if ! [ -f /etc/opnix-token ] && command -v opnix >/dev/null 2>&1; then
        sudo opnix token set
      fi
      nh os switch . -- "$@"
    '';

    sync.exec = ''
      update-flake "$@"
      switch "$@"
    '';
  };

  enterShell = ''
    echo "Available: fmt, update-deps, write-flake, update-flake, build, switch, sync"
  '';
}
