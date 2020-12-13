{ config, pkgs, ... }:

let
  cfg = config.nielx;
  utils = import ../utils.nix config pkgs;
in
{
  imports =
    [ ./hardware-configuration.nix
      ./niv.nix
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

  networking.networkmanager.enable = true;

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

  # For X11 and pulseaudio to work with LXD.
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
      initExtra = ''
${cfg.commonBash}

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

    home.file.".stumpwmrc".source = utils.symlinkTo "stumpwmrc";
  };

  # Enable things through the nielx wrapper.  Sensitive information is kept
  # separate.
  nielx = {
    shellPromptColor = "1;32m";

    path-scripts = {
      enable = true;
      scripts = [
        # https://github.com/nqpz/disktap
        {
          dir = "disktap";
          script = "disktap";
          nix = false;
        }

        # https://github.com/nqpz/alart
        {
          dir = "alart";
          script = "alart";
          nix = true;
        }

        # https://github.com/nqpz/aeltei
        {
          dir = "aeltei";
          script = "aeltei";
          nix = true;
        }
      ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
