{
  pkgs ? import <nixpkgs> {},
  shell-scripts ? import /etc/nixos/custom/shell-scripts.nix {
    pkgs = pkgs,
    canonical-remote ? "https://github.com/nextmoose/secrets.git",
    branch ? "master"
  }
}:
pkgs.mkShell {
  buildInputs = [ shell-scripts ];
  shellHook = "${shell-scripts.pass}/bin/pass ${canonical-remote} ${branch}";
}