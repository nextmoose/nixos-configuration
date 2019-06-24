{
  pkgs ? import <nixpkgs> {},
  staples ? import ../staples.nix {
    pkgs = pkgs;
  }
} :
pkgs.mkShell {
  buildInputs = [
    pkgs.gnupg
    pkgs.git
    pkgs.pass
    staples.init-read-only-pass.implementation
  ];
}