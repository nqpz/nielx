{ config, pkgs, ... }:

let
  cfg = config.nielx;
  xmodmapFile = pkgs.writeScript "xmodmap" (builtins.readFile ./xmodmap);
in
{
  services.fractalart.enable = true;

  # Touchpad
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = false;

  services.displayManager.defaultSession = "xfce+stumpwm";

  services.xserver = {
    enable = true;

    xkb.layout = "dk";
    xkb.variant = "dvorak";
    xkb.options = "ctrl:swapcaps";

    displayManager = {
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

  # nixpkgs.config.packageOverrides = pkgs: {
  #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  # };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
      ocl-icd
    ];

    enable32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
  };
}
