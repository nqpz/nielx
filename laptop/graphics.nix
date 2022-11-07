{ config, pkgs, ... }:

let
  cfg = config.nielx;
  xmodmapFile = pkgs.writeScript "xmodmap" (builtins.readFile ./xmodmap);
in
{
  services.fractalart.enable = true;

  services.xserver = {
    enable = true;

    layout = "dk";
    xkbVariant = "dvorak";
    xkbOptions = "ctrl:swapcaps";

    # Touchpad
    libinput.enable = true;
    libinput.touchpad.tapping = false;

    displayManager = {
      defaultSession = "xfce+stumpwm";
      lightdm.enable = true;
      sessionCommands = ''
${pkgs.xorg.xhost}/bin/xhost +local:lxd
${pkgs.xorg.setxkbmap}/bin/setxkbmap dk dvorak
${pkgs.xorg.setxkbmap}/bin/setxkbmap -option ctrl:swapcaps
${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapFile}
${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
${pkgs.feh}/bin/feh --bg-fill ${cfg.home}/.background-image
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
  };

  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
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
      intel-compute-runtime
    ];

    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel ];
  };
}
