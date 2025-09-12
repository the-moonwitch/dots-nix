#! /usr/bin/env nix-shell
#! nix-shell -p just -i "just --justfile"

nh := "nix run nixpkgs#nh --"
nh-flags := ""

default: sync

opnix-auth:
    if ! [ -f /etc/opnix-token ] && command -v opnix >/dev/null 2>&1; then sudo opnix token set; fi

# Format all files in the flake
[group('lint')]
fmt:
    nix fmt
    nix fmt

# Update flake dependency versions
[group('build')]
update-deps *FLAGS:
    nix flake update {{ FLAGS }}

# Sync inputs to flake.nix
[group('build')]
write-flake *FLAGS:
    nix run ".#write-flake" {{ FLAGS }}

# Update and write flake dependencies, then format the repo
[group('build')]
update-flake *FLAGS: (update-deps FLAGS) (write-flake FLAGS)

# Build the os and home config
[group('build')]
build *FLAGS: (write-flake FLAGS)
    {{ nh }} os build . -- {{ nh-flags }} {{ FLAGS }}

# Switch the config
[group('build')]
[group('update')]
switch *FLAGS: opnix-auth
    {{ nh }} os switch . -- {{ nh-flags }} {{ FLAGS }}

# Fully update all dependencies and configs and switch
[group('build')]
[group('update')]
sync *FLAGS: (update-flake FLAGS) (switch FLAGS)
