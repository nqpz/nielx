{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mailutils
    imagemagick
    stack
    ffmpeg-full
    x264
    bento4
    surf
    lynx
  ];
}
