{
  pkgs ? import <nixpkgs> {},
  staples ? import ../staples.nix {
    pkgs = pkgs;
  },
  name ? "Emory"
}:
pkgs.mkShell {
  shellHook = "${staples.shells.homer}/bin/homer ${name}";
}