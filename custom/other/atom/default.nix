{
  pkgs ? import <nixpkgs> {},
  atom-package
}:
pkgs.stdenv.mkDerivation {
  name = "atom";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper pkgs.atom ];
  buildPhase = ''
    chmod 0500 scripts/*.sh &&
      mkdir atom &&
      export ATOM_HOME=atom &&
      apm install ${atom-package} &&
      true
  '';
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out &&
      makeWrapper \
        $out/scripts/atom.sh \
        $out/bin/atom \
        --set ATOM_HOME "$out/atom" \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.atom] } &&
    true
  '';
}
