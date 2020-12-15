{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    imagemagick
    stack
  ];
}
