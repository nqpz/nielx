{ config, pkgs, ... }:

let
  sources = import ./nix/sources.nix;

  sources_pkgs = import sources.nixpkgs { config.allowUnfree = true; };
  overlay_sources = _: _: sources_pkgs;

  nixos-hardware = sources.nixos-hardware;

  overlay_niv = _: _: {
    niv = (import sources.niv {}).niv;
  };
in
{
  imports =
    [ (import sources.home-manager {}).nixos
      "${nixos-hardware}/lenovo/thinkpad/t480s"
      "${nixos-hardware}/common/pc/ssd"
    ];

  nixpkgs.overlays = [ overlay_sources overlay_niv ];
  environment.systemPackages = [ pkgs.niv ];
}
