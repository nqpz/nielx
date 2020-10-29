cfg: pkgs:

pkgs.writeScript "exports" ''
export PATH=\
$HOME/bin:\
$HOME/.local/bin:\
${cfg.root}/laptop/bin:\
$PATH

export EDITOR=stumpemacsclient

export PYOPENCL_CTX=""
export LIBVA_DRIVER_NAME=iHD

. $HOME/config/laptop/profile_private
''
