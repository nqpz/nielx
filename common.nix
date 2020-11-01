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
