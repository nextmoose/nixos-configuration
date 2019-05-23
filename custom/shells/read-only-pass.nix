{
  pkgs ? import <nixpkgs> {},
  staples ? import ./staples.nix {
    pkgs = pkgs;
  },
  shell-scripts ? import /etc/nixos/custom/shell-scripts.nix {
    pkgs = pkgs;
    staples = staples;
  },
  canonical-remote ? "https://github.com/nextmoose/secrets.git",
  branch ? "master"
}:
pkgs.mkShell {
  buildInputs = [ shell-scripts ];
  shellHook = "${shell-scripts.pass}/bin/pass ${canonical-remote} ${branch}";
}