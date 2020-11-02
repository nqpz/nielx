{ config, pkgs, ... }:

let
  cfg = config.nielx;
in
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    autoOptimiseStore = true;
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = "AddKeysToAgent yes"; # add keys on first ssh
    agentTimeout = "24h";
    askPassword = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
  };

  services.lorri.enable = true;
  environment.systemPackages = [
    pkgs.direnv
    (pkgs.writeScriptBin "lorri-direnv-init" ''#!/bin/sh
echo 'eval "$(lorri direnv)"' > .envrc
direnv allow
'')
  ];

  home-manager.useGlobalPkgs = true;

  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Europe/Copenhagen";

  networking.hostName = cfg.hostname;

  programs.screen.screenrc = ''
startup_message off
escape ^Ww
'';

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      historySize = 50000;
    };

    home.file.".gnupg/gpg-agent.conf".text = ''
max-cache-ttl 86400
default-cache-ttl 86400
'';

    programs.git = let
      excludesFile = pkgs.writeText "global-gitignore" ''
.envrc
'';
    in {
      enable = true;
      userName = cfg.fullName;
      userEmail = cfg.email;
      iniContent.pull.ff = "only";
      signing = {
        signByDefault = true;
        key = cfg.gpgKey;
      };
      extraConfig = {
        core = {
          excludesfile = "${excludesFile}";
        };
      };
    };
  };

  programs.autojump.enable = true;

  nielx = {
    gpgKey = "38EEEBCE67324F19";
    commonBash = ''
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
PS1="\$(ps1_exit_code) \033[$ps1_date_color[\$(date +%R)] \033[$ps1_prompt_color\u@\h:\w\\$\033[0m "
'';
    commonShellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "mv" = "mv -n";
      "dtrx" = "dtrx -n";
      "duhst" = "du -hsc";
    };
    www.acmeSSL = true;
    postfix_relayhost.enable = true;
  };
}
