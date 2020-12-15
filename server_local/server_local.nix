{ config, pkgs, ... }:

let
  cfg = config.nielx;
in
{
  imports =
    [ ./hardware-configuration.nix
      ./niv.nix
      ../common.nix
      ./packages.nix
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 0;
  };

  networking = {
    useDHCP = false; # deprecated
    interfaces.eno1.useDHCP = true; # new dhcp config
    interfaces.wlp58s0.useDHCP = false;
  };

  users.users."${cfg.user}" = {
    isNormalUser = true;
    home = "${cfg.home}";
    description = "${cfg.fullName}";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    programs.bash = {
      initExtra = cfg.commonBash;
      shellAliases = cfg.commonShellAliases;
    };
  };

  # Enable things through the nielx wrapper.  Sensitive information is kept
  # separate.
  nielx = {
    shellPromptColor = "1;34m";
    simple-emacs.enable = true;
    sshserver.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
