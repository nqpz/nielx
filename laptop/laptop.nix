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
      ./audio.nix
      # ./virtualbox.nix
    ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };

  networking = {
    # https://uncensoreddns.org/
    # nameservers = [
    #   "91.239.100.100"
    #   "89.233.43.71"
    # ];

    networkmanager = {
      enable = true;
      # dns = "none";
    };
  };

  console.useXkbConfig = true;

  services.redshift.enable = true;


  # I copied the below code from somewhere, but now it's made my NNS resolving super slow.

  # services.printing.enable = true;
  # services.printing.drivers = [ pkgs.hplip ];
  # # Allow printing from network printers.
  # services.avahi.enable = true;
  # services.avahi.nssmdns = false; # Use the settings from below
  # # settings from avahi-daemon.nix where mdns is replaced with mdns4
  # system.nssModules = with pkgs.lib; optional (!config.services.avahi.nssmdns) pkgs.nssmdns;
  # system.nssDatabases.hosts = with pkgs.lib; optionals (!config.services.avahi.nssmdns) (mkMerge [
  #   (mkOrder 900 [ "mdns4_minimal [NOTFOUND=return]" ]) # must be before resolve
  #   (mkOrder 1501 [ "mdns4" ]) # 1501 to ensure it's after dns
  # ]);

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.lxc.enable = true;
  virtualisation.lxc.lxcfs.enable = true;
  virtualisation.lxd.enable = true;
  virtualisation.lxd.recommendedSysctlSettings = true;

  # For X11 and pulseaudio to work with LXD.
  users.users.root.subUidRanges = [{ startUid = 1000; count = 1; }];
  users.users.root.subGidRanges = [{ startGid = 100; count = 1; }];

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

    home.file.".urlscan".text = "COMMAND firefox u";

    programs.mpv = {
      enable = true;
      config = {
        fullscreen = "yes";
        hwdec = "auto-safe";
        vo = "gpu";
        ytdl-format = "bestvideo+bestaudio";
      };
    };

    home.file.".emacs.d/init.el".text = ''
(add-to-list 'load-path "${cfg.root}/laptop/emacs")
(require 'niels)
'';

    home.file.".stumpwmrc".source = utils.symlinkTo "stumpwmrc.cl";

    home.file.".config/terminator/config".source = ./terminator.cfg;
  };

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      steam = {
        executable = "${pkgs.steam}/bin/steam";
        profile = "${pkgs.firejail}/etc/firejail/steam.profile";
      };
      # todo: chrome etc.
    };
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

    geomyidae = {
      enable = true;
      allowExternal = false;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
