# ide container for react.js
{
  pkgs ? import <nixpkgs> {},
  development-environment-init
}:
let
  old-node = (import ../native/node/default.nix {
      pkgs = pkgs;
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
    environment.variables.DISPLAY=":0.0";
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        development-environment-init
        (import ../other/atom/default.nix {
          pkgs = pkgs;
          atom-packages = "git-plus react";
        })
        (import ../node/create-react-app/default.nix {
          pkgs = pkgs;
        })
        pkgs.git
        pkgs.trash-cli
        pkgs.glib.dev
        old-node
        pkgs.nodePackages.node2nix
      ];
    };
  };
  tmpfs = [ "/home" ];
}
