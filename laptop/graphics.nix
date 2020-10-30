{ config, pkgs, ... }:

let
  cfg = config.nielx;
  xmodmapFile = pkgs.writeScript "xmodmap" (builtins.readFile ./xmodmap);
in
{
  services.xserver = {
    enable = true;

    layout = "dk";
    xkbVariant = "dvorak";
    xkbOptions = "ctrl:swapcaps";

    # Touchpad
    libinput.enable = true;
    libinput.tapping = false;

    displayManager = {
      defaultSession = "xfce+stumpwm";
      autoLogin = {
        enable = true;
        user = "niels";
      };
      lightdm = {
        enable = true;
      };
      sessionCommands = ''
${pkgs.xorg.xhost}/bin/xhost +local:lxd
${pkgs.xorg.setxkbmap}/bin/setxkbmap dk dvorak
${pkgs.xorg.setxkbmap}/bin/setxkbmap -option ctrl:swapcaps
${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapFile}
${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
. ${import ./exports.nix cfg pkgs}
'';
    };

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    windowManager.stumpwm.enable = true;

    videoDrivers = [ "beignet" ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
      beignet
    ];

    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel ];
  };
}
