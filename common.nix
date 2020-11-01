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
    agentTimeout = "8h";
  };

  services.lorri.enable = true;
  environment.systemPackages = [ pkgs.direnv ];

  home-manager.useGlobalPkgs = true;

  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Europe/Copenhagen";

  networking.hostName = cfg.hostname;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  home-manager.users."${cfg.user}" = { pkgs, ... }: {
    programs.git = let
      excludesFile = pkgs.writeText "global-gitignore" ''
.envrc # lorri
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

  nielx = {
    gpgKey = "38EEEBCE67324F19";
    commonShellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "mv" = "mv -n";
      "dtrx" = "dtrx -n";
      "duhst" = "du -hsc";
    };
  };
}
