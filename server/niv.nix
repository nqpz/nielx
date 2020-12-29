{ config, pkgs, ... }:

let
  sources = import ./nix/sources.nix;

  overlay_niv = _: _: {
    niv = (import sources.niv {}).niv;
  };
in
{
  imports =
    [ "${sources.home-manager}/nixos"
    ];

  nix.nixPath = [
    "nixpkgs=${sources.nixpkgs}"
    "nixos=${sources.nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nixpkgs.pkgs = import sources.nixpkgs {
    overlays = [ overlay_niv ];
  };

  environment.systemPackages = [ pkgs.niv ];
}
