#! /usr/bin/env nix-shell
#! nix-shell -p just -i "just --justfile"

[group('lint')]
fmt:
    nix fmt

[group('build')]
update-deps *FLAGS:
    nix flake update cadence {{ FLAGS }}

[group('build')]
write-flake *FLAGS: (update-deps FLAGS)
    nix run ".#write-flake" {{ FLAGS }}
    just fmt

[group('build')]
build *FLAGS: (write-flake FLAGS)
    nix run nixpkgs#nh -- os build . {{ FLAGS }}

[group('build')]
[group('run')]
switch *FLAGS: (write-flake FLAGS)
    nix run nixpkgs#nh -- os switch . {{ FLAGS }}
