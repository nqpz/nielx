{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    imagemagick
    stack
    ffmpeg-full
    x264
    bento4
  ];
}
