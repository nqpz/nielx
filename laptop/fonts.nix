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
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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
      ubuntu-classic
      ttf_bitstream_vera
      gentium
      lmodern

      # unfree
      corefonts
      vista-fonts
      google-fonts
      symbola
    ];
  };
}
