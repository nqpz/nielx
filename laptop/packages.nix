{ config, pkgs, ... }:

let
  utils = import ../utils.nix config pkgs;
in
{
  environment.systemPackages = with pkgs; [
    neomutt
    (utils.binWrapper "mutt" "${pkgs.neomutt}/bin/neomutt")
    offlineimap
    urlview
    stack
    imagemagick
    mplayer
    vlc
    ffmpeg-full
    x264
    bento4
    kdenlive
    firefox
    (chromium.override { enableVaapi = true; })
    surf
    w3m
    usbutils
    terminator
    zathura
    evince
    rustup
    sox
    go-mtpfs
    syncplay
    tightvnc
    valgrind
    nmap
    pandoc
    youtube-dl
    transmission-remote-gtk
    acpi
    iw
    gimp
    inkscape
    texlive.combined.scheme-full
    ghostscript
    aalib
    libreoffice
    gpicview
    ascii
    swiProlog
    (utils.binWrapper "pl" "${pkgs.swiProlog}/bin/swipl")
    aegisub
    gparted
    gnome3.nautilus
    audacity
    mediainfo
    gnome3.cheese
    xawtv
    xorg.xmodmap
    xorg.setxkbmap
    xorg.xrandr
    xorg.xeyes
    stumpish
    rlwrap
    stalonetray
    xsel
    xmacro
    ocaml
    dune_2
    ocamlPackages.findlib
    ocamlPackages.core
    ocamlPackages.async
    ocamlPackages.async_ssl
    ntfs3g
    exfat-utils
    baobab
    signal-desktop
    (utils.binWrapper "signal" "${pkgs.signal-desktop}/bin/signal-desktop")
    glxinfo
    element-desktop
    (utils.binWrapper "element" "${pkgs.element-desktop}/bin/element-desktop")
    jitsi-meet-electron
    xmoto
    cfdg
    wineFull
    dosbox
    qemu
    nur.repos.mic92.nixos-shell
    supercollider

    (pkgs.writeScriptBin "stumpemacsclient" ''#!/bin/sh
set -e # Exit on first error.
${pkgs.stumpish}/bin/stumpish 'eval (stumpwm::save-es-called-win)' > /dev/null
${pkgs.emacs}/bin/emacsclient "$@"
'')

    (pkgs.writeScriptBin "battery" ''#!/bin/sh
${pkgs.acpi}/bin/acpi | sed -r 's/^[^0-9]*[0-9]+[^0-9]*([0-9]+).*$/\1/'
'')

    (pkgs.writeScriptBin "webcam-image" ''#!/bin/sh
set -e # Exit on first error.
out="$1"
temp_dir="$(mktemp -d)"
temp="$temp_dir/streamer.jpeg"
${pkgs.xawtv}/bin/streamer -f jpeg -j 90 -s 1280x720 -o $temp
mv "$temp" "$out"
rmdir "$temp_dir"
'')

    (pkgs.writeScriptBin "webcam-video" ''#!/bin/sh
out="$1"
${pkgs.ffmpeg}/bin/ffmpeg -f video4linux2 -s 1280x720 -r 25 -i /dev/video0 -f oss -i /dev/dsp -f webm "$out"
'')

    (pkgs.writeScriptBin "pdfcompress" ''#!/bin/sh
in="$1"
out="$2"
mode="$3" # screen, ebook, or printer
${pkgs.ghostscript}/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$mode -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$out" "$in"
'')

    # unfree
    spotify
    steam
    slack
    google-chrome
    (utils.binWrapper "chrome" "${pkgs.google-chrome}/bin/google-chrome-stable")
    discord
    (utils.binWrapper "discord" "${pkgs.discord}/bin/Discord")
    zoom-us
  ];
}
