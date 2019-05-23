{
  pkgs ? import <nixpkgs> {},
  staples ? import ../staples.nix {
    pkgs = pkgs;
  }
}:
pkgs.mkShell {
  shellHook = "${staples.shells.homer}/bin/homer";
}