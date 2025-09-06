#!/usr/bin/env just --justfile

fmt:
  nix fmt

write-flake *FLAGS:
  nix run ".#write-flake" {{FLAGS}}

build *FLAGS: (write-flake FLAGS)
  nix run nixpkgs#nh -- os build . {{FLAGS}}

switch *FLAGS: (write-flake FLAGS)
  nix run nixpkgs#nh -- os switch . {{FLAGS}}