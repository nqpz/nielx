{ config, pkgs, ... }:

let
  cfg = config.nielx;

  # Sometimes it's nice to be able to live-edit a file instead of waiting for
  # 'nixos-rebuild switch' to copy it and finish.  This function addresses that
  # usecase by making a derivation that symlinks to the actual file in this
  # repository.  I guess this is a bit wrong.
  symlinkTo = source:
    let
      linkDir = pkgs.stdenv.mkDerivation {
        name = "symlink";
        phases = "installPhase";
        installPhase = ''
mkdir -p $out
ln -s ${cfg.root}/laptop/${source} $out/symlink
'';
      };
    in
      "${linkDir}/symlink";
in
{
  imports =
    [ ./hardware-configuration.nix
      ./niv.nix
      ../nielx.nix
      ../common.nix
      ./packages.nix
      ./fonts.nix
      ./graphics.nix
      ./mail.nix
    ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };

  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;

  security.apparmor.enable = true; # needed for lxd anyway

  console.useXkbConfig = true;

  services.redshift.enable = true;

  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  virtualisation.docker.enable = true;

  virtualisation.lxc.enable = true;
  virtualisation.lxd.enable = true;
  virtualisation.lxd.recommendedSysctlSettings = true;

  # For X11 and pulseaudio to work.
  users.users.root.subUidRanges = [{ startUid = 1000; count = 1; }];
  users.users.root.subGidRanges = [{ startGid = 100; count = 1; }];

  virtualisation.virtualbox.host.enable = true;

  # unfree
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  users.extraGroups.vboxusers.members = [ cfg.user ];

  users.users."${cfg.user}" = {
    isNormalUser = true;
    home = "${cfg.home}";
    description = "${cfg.fullName}";
    extraGroups = [ "wheel" "networkmanager" "lxc" "lxd" "docker" ];
  };

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      historySize = 50000;
      initExtra = ''
eval "$(direnv hook bash)"

ps1_date_color='1;34m'
ps1_prompt_color='${cfg.shellPromptColor}'
ps1_exit_code() {
    ps1_exit_code=$?
    if [ $ps1_exit_code = 0 ]; then
        ps1_exit_color='1;32m'
    else
        ps1_exit_color='1;31m'
    fi
    echo -e "\033[$ps1_exit_color[$(printf %3d $ps1_exit_code)]"
}
PS1="\$(ps1_exit_code) \033[$ps1_date_color[$(date +%R)] \033[$ps1_prompt_color\u@\h:\w\\$\033[0m "

. ${cfg.home}/config/laptop/bash_private
'';
      profileExtra = ". ${import ./exports.nix cfg pkgs}";
      shellAliases = cfg.commonShellAliases // {
        "emc" = "emacsclient -n";
      };
    };

    home.file.".stalonetrayrc".text = ''
window_type normal
background white
'';

    home.file.".urlview".text = "COMMAND firefox u";

    programs.mpv = {
      enable = true;
      config = {
        fullscreen = "yes";
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
        ytdl-format = "bestvideo+bestaudio";
      };
    };

    home.file.".emacs.d/init.el".text = ''
(add-to-list 'load-path "${cfg.root}/laptop/emacs")
(require 'niels)
'';

    home.file.".stumpwmrc".source = symlinkTo "stumpwmrc";
  };

  # Enable things through the nielx wrapper.  Sensitive information is kept
  # separate.
  nielx = {
    shellPromptColor = "1;32m";
    rdiff-backup.enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
