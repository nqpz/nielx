{ config, pkgs, ... }:

let
  cfg = config.nielx;
  utils = import ../utils.nix config pkgs;
in
{
  virtualisation.virtualbox.host.enable = true;

  users.extraGroups.vboxusers.members = [ cfg.user ];

  environment.systemPackages = with pkgs; [
    (utils.binWrapper "virtualbox" "${pkgs.virtualbox}/bin/VirtualBox")
  ];
}
