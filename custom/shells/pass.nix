{
  pkgs ? import <nixpkgs> {},
  staples ? import /etc/nixos/custom/staples.nix {
    pkgs = pkgs;
  },
  foo ? "alaska"
}:
pkgs.mkShell {
  inputsFrom = [ pkgs.bash ];
  buildInputs = [ pkgs.bash pkgs.cowsay ];
  shellHook = ''
    echo hello ${foo} | cowsay &&
      cleanup() {
        echo bye | cowsay &&
	  true
      } &&
      trap cleanup EXIT
  '';
}