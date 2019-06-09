{
  pkgs ? import <nixpkgs> {}
} :
pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.jetbrains.idea-community
  ];
}