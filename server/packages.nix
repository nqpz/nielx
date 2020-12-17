{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mailutils
  ];
}
