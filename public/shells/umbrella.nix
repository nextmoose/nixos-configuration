{
  pkgs ? import <nixpkgs> {},
  staples ? import ../staples.nix {
    pkgs = pkgs;
  }
} :
pkgs.mkShell {
  buildInputs = [
    staples.configure-nixos.implementation
  ];
}