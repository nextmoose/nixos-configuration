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
  ];
}