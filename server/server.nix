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
      ./www.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
  };

  networking = {
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    usePredictableInterfaceNames = false;
  };

  services.journald.extraConfig = "SystemMaxUse=1GB";

  environment.variables = {
    EDITOR = "emacs";
  };

  users.users."${cfg.user}" = {
    isNormalUser = true;
    home = "${cfg.home}";
    description = "${cfg.fullName}";
    extraGroups = [ "wheel" "networkmanager" "znc" ];
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
    shellPromptColor = "1;33m";
    simple-emacs.enable = true;
    sshserver.enable = true;
    duplicity.enable = true;
    longview.enable = true;
    matrix.enable = true;
    feedmael.enable = true;
    irc.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
