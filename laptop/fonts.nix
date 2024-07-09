{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      inconsolata
      # emojione
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      fira
      fira-code
      fira-mono
      montserrat
      iosevka
      hack-font
      terminus_font
      anonymousPro
      freefont_ttf
      dejavu_fonts
      ubuntu_font_family
      ttf_bitstream_vera
      gentium
      lmodern

      # unfree
      corefonts
      vistafonts
      google-fonts
      symbola
    ];
  };
}
