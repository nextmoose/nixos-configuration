# ide container for react.js
{
  pkgs ? import <nixpkgs> {},
  development-environment-init
}:
let
  old-node = (import ../native/node/default.nix {
      pkgs = pkgs;
    });
    npm-global-install = (import ../utils/custom-script-derivation.nix{
        pkgs = pkgs;
        src = ../scripts/npm-global-install;
        name = npm-global-install;
        dependencies = [ old-node pkgs.coreutils ];
      });
in
{
  bindMounts = {
    "/srv/host" = {
      hostPath = "/";
      isReadOnly = true;
    };
    "/srv/home" = {
      hostPath = "/home/user";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables = {
      DISPLAY=":0.0";
      NPM_PACKAGES="/home/user/.npm-packages";
   };
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        development-environment-init
        (import ../other/atom/default.nix {
          pkgs = pkgs;
          atom-packages = "git-plus react";
        })
        pkgs.git
        pkgs.trash-cli
        pkgs.glib.dev
        old-node
        pkgs.nodePackages.node2nix
        npm-global-install
      ];
    };
  };
  tmpfs = [ "/home" ];
}
