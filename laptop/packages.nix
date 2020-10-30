{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nix-index
    emacs
    neomutt
    offlineimap
    urlview
    ack
    file
    tmux
    screen
    stack
    imagemagick
    mplayer
    vlc
    ffmpeg
    x264
    bento4
    firefox
    (chromium.override { enableVaapi = true; })
    surf
    usbutils
    terminator
    zathura
    evince
    rustup
    pavucontrol
    sox
    whois
    wget
    go-mtpfs
    git
    syncplay
    calibre
    tightvnc
    gcc
    clang
    binutils
    gnumake
    cmake
    stdmanpages
    manpages
    valgrind
    nmap
    gnupg
    bash-completion
    wmctrl
    autossh
    sshfs
    pandoc
    htop
    iotop
    nload
    pciutils
    youtube-dl
    transmission-remote-gtk
    acpi
    dtrx
    rdiff-backup
    zip
    unzip
    iw
    gimp
    inkscape
    texlive.combined.scheme-full
    w3m
    lynx
    aalib
    libreoffice
    gpicview
    toilet
    bc
    ascii
    swiProlog
    tree
    aegisub
    gparted
    feh
    gnome3.nautilus
    gnum4
    automake
    autoconf
    libtool
    socat
    audacity
    gnuapl
    mediainfo
    bind
    bat
    rclone
    zile
    gnome3.cheese
    xawtv
    gnome3.dconf-editor
    xorg.xmodmap
    xorg.setxkbmap
    xorg.xsetroot
    xorg.xrandr
    xorg.xdpyinfo
    xorg.xeyes
    xorg.xhost
    stumpish
    rlwrap
    stalonetray
    xdotool
    xsel
    xmacro
    (python27.withPackages (ps: with ps; [ numpy pygtk ]))
    (python3.withPackages (ps: with ps; [ numpy setuptools requests termcolor pyyaml pygments ]))
    ocaml
    opam
    ocamlPackages.base
    ocamlPackages.findlib
    dune
    ntfs3g
    exfat-utils
    baobab
    lm_sensors
    signal-desktop
    pngcrush
    glxinfo
    cudatoolkit
    element-desktop
    qjackctl
    supercollider
    supercollider_scel
    jitsi-meet-electron

    (pkgs.writeScriptBin "stumpemacsclient" ''
#!/bin/sh
set -e # Exit on first error.
${pkgs.stumpish}/bin/stumpish 'eval (stumpwm::save-es-called-win)' > /dev/null
${pkgs.emacs}/bin/emacsclient "$@"
'')

    (pkgs.writeScriptBin "battery" ''
#!/bin/sh
${pkgs.acpi}/bin/acpi | sed -r 's/^[^0-9]*[0-9]+[^0-9]*([0-9]+).*$/\1/'
'')

    # Requires $MAILDIR to be set.
    (pkgs.writeScriptBin "checkmail" ''
#!/bin/sh
echo "Email: $(ls $MAILDIR/INBOX/new | wc -l)"
'')

    # unfree
    spotify
    steam
    slack
    google-chrome
    discord
  ];
}
