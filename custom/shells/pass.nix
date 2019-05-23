{
  pkgs ? import <nixpkgs> {},
  staples ? import /etc/nixos/custom/staples.nix {
    pkgs = pkgs;
  },
  canonical-url ? "https://github.com/nextmoose/secrets.git",
  branch ? "master"
}:
pkgs.mkShell {
  buildInputs = [ pkgs.cowsay pkgs.pass pkgs.mktemp ];
  shellHook = "${staples.pass}/bin/pass ";
}