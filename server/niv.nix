{ config, pkgs, ... }:

let
  sources = import ./nix/sources.nix;

  sources_pkgs = import sources.nixpkgs {};
  overlay_sources = _: _: sources_pkgs;

  overlay_niv = _: _: {
    niv = (import sources.niv {}).niv;
  };
in
{
  imports =
    [ (import sources.home-manager {}).nixos
    ];

  nixpkgs.overlays = [ overlay_sources overlay_niv ];
  environment.systemPackages = [ pkgs.niv ];
}

