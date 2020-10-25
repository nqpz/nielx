{ config, pkgs, ... }:

let
  cfg = config.nielx;
in
{
  imports =
    [ ./hardware-configuration.nix
      ./niv.nix
      ../nielx.nix
      ./simple-emacs.nix
      ./packages.nix
      ./www.nix
    ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    autoOptimiseStore = true;
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
  };

  networking = {
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    usePredictableInterfaceNames = false;
    hostName = cfg.hostname;
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = "AddKeysToAgent yes"; # add keys on first ssh
    agentTimeout = "8h";
  };

  systemd.services."status_email_user@" =
    let
      systemd_email = pkgs.writeScript "systemd_email" ''#!/bin/sh
${pkgs.postfix}/bin/sendmail -t <<EOF
To: ${cfg.email}
# Subject: [nixpille systemd] $1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8

$(systemctl status --full "$1")
EOF
'';
    in {
      enable = true;
      path = with pkgs; [ systemd postfix ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${systemd_email} %i";
        User = "root";
        Group = "systemd-journal";
      };
    };

  services.journald.extraConfig = "SystemMaxUse=1GB";

  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Europe/Copenhagen";

  environment.variables = {
    EDITOR = "emacs";
  };

  services.lorri.enable = true;
  environment.systemPackages = [ pkgs.direnv ];

  home-manager = {
    useGlobalPkgs = true;
  };

  users.users."${cfg.user}" = {
    isNormalUser = true;
    home = "${cfg.home}";
    description = "${cfg.fullName}";
    extraGroups = [ "wheel" "networkmanager" "znc" ];
  };

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      historySize = 50000;
      initExtra=''eval "$(direnv hook bash)"'';
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
      };
    };

    programs.autojump.enable = true;

    programs.git = {
      enable = true;
      userName = cfg.fullName;
      userEmail = cfg.email;
      iniContent.pull.ff = "only";
    };
  };

  # Enable things through the nielx wrapper.  Sensitive information is kept
  # separate.
  nielx = {
    sshserver.enable = true;
    duplicity.enable = true;
    longview.enable = true;
    matrix.enable = true;
    feedmael.enable = true;
    irc.enable = true;
    postfix_relayhost.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
