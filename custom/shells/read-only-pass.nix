{
  pkgs ? import <nixpkgs> {},
  staples ? import ../staples.nix {
    pkgs = pkgs;
  },
  canonical-remote ? "https://github.com/nextmoose/secrets.git",
  branch ? "master"
}:
pkgs.mkShell {
  buildInputs = [ staples.shells.read-only-pass ];
  shellHook = "${staples.shells.read-only-pass}/bin/read-only-pass ${canonical-remote} ${branch}";
}