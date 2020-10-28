{ config, pkgs, ... }:

let
  cfg = config.nielx;
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
      initExtra=''
. ${cfg.home}/prog/bash/bash-functions

eval "$(direnv hook bash)"
'';
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
      };
    };

    programs.autojump.enable = true;

    services.stalonetray = {
      enable = true;
      config = {
        window_type = "normal";
        background = "white";
      };
    };

    home.file.".urlview".text = "COMMAND firefox u";

    programs.git = let
      excludesFile = pkgs.writeText "global-gitignore" ''
.envrc
'';
    in {
      enable = true;
      userName = cfg.fullName;
      userEmail = cfg.email;
      iniContent.pull.ff = "only";
      extraConfig = {
        core = {
          excludesfile = "${excludesFile}";
        };
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
