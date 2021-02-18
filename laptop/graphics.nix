{ config, pkgs, ... }:

let
  cfg = config.nielx;
  xmodmapFile = pkgs.writeScript "xmodmap" (builtins.readFile ./xmodmap);
  lockScript = pkgs.writeScriptBin "lock-screen" ''
#!/bin/sh

exec ${pkgs.lightlocker}/bin/light-locker-command -l
'';
  lockScriptUnlessWifi = pkgs.writeScriptBin "lock-screen-unless-wifi" ''
#!/bin/sh

set -e

if ! ${pkgs.iw}/bin/iw wlp3s0 link | grep -q ${cfg.graphics.lockUnlessWifi}; then
   ${lockScript}/bin/lock-screen
fi
'';
in
{
  services.fractalart.enable = true;

  environment.systemPackages = [ lockScript ];

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
if ! pgrep light-locker; then
  ${pkgs.lightlocker}/bin/light-locker --lock-on-lid &
  disown
fi
if ! pgrep xss-lock; then
  ${pkgs.xss-lock}/bin/xss-lock -n ${lockScriptUnlessWifi}/bin/lock-screen-unless-wifi -- ${lockScript}/bin/lock-screen -n &
  disown
fi
{
  sleep 15
  ${pkgs.xorg.xset}/bin/xset s on
  ${pkgs.xorg.xset}/bin/xset s ${builtins.toString cfg.graphics.timeToLock} ${builtins.toString (cfg.graphics.timeToLockOnWifi - cfg.graphics.timeToLock)}
  ${pkgs.feh}/bin/feh --bg-fill ${cfg.home}/.background-image
} &
disown
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

    videoDrivers = [ "intel" ];
    useGlamor = true;
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
    ];

    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel ];
  };
}
