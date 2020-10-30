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
      "${sources.nixos-hardware}/lenovo/thinkpad/t480s"
      "${sources.nixos-hardware}/common/pc/ssd"
    ];

  nix.nixPath = [
    "nixpkgs=${sources.nixpkgs}"
    "nixos=${sources.nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  nixpkgs.pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    overlays = [ overlay_niv ];
  };

  environment.systemPackages = [ pkgs.niv ];
}
