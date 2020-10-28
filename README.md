# nielx

This (work-in-progress!) repository contains my public
[NixOS](https://nixos.org/) configurations.  The documentation is a bit
lacking and will probably continue that way, but you might find it
useful if you need a setup close to what I have.

I have a separate private configuration (containing passwords and other
sensitive information) that uses this repository as its base.

I'm also using a few NixOS-related community projects:

- [Home Manager](https://github.com/nix-community/home-manager)
- [niv](https://github.com/nmattia/niv)
- [lorri](https://github.com/target/lorri)


## Starting points

You might want to look at [laptop/laptop.nix](laptop/laptop.nix) and
[server/server.nix](server/server.nix) to get an overview of how my
laptop and my server are constructed.  [nielx.nix](nielx.nix) contains
general modules that can be applied to any configuration.
