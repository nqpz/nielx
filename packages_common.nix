{ config, pkgs, ... }:

let
  cfg = config.nielx;
in
{
  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
    rsync
    htop
    iotop
    pciutils
    nload
    emacs
    ack
    manpages
    stdmanpages
    file
    tmux
    screen
    whois
    wget
    git
    gcc
    clang
    binutils
    gnumake
    cmake
    bash-completion
    autojump
    sshfs
    dtrx
    zip
    unzip
    tree
    bat
    pngcrush
    python3
    jq
    bind
    lm_sensors

    (pkgs.writeScriptBin "upgrade-nixos" ''#!/bin/sh
set -e # Exit on first error.

sudo true # Ask for eventual sudo password up front and hope it lasts.

cd ${cfg.root}/${cfg.nixos_config_directory}

${pkgs.niv}/bin/niv update

nixpkgs=$(${pkgs.nix}/bin/nix eval '(let sources = import ./nix/sources.nix; in "${"$" + "{sources.nixpkgs}"}")' | tr -d '"')

sudo nixos-rebuild switch -I nixpkgs=$nixpkgs -I nixos=$nixpkgs -I nixos-config=/etc/nixos/configuration.nix
'')
  ];
}
