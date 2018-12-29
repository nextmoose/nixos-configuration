{
  pkgs ? import <nixpkgs> {},
  atom-packages
}:
pkgs.stdenv.mkDerivation {
  name = "atom";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper pkgs.atom ];
  buildPhase = ''
    chmod 0500 scripts/*.sh &&
      mkdir atom &&
      export ATOM_HOME=atom &&
      apm install ${atom-packages} &&
      true
  '';
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out &&
      makeWrapper \
        $out/scripts/atom.sh \
        $out/bin/atom \
        --set STORE_DIR "$out" \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.atom pkgs.git pkgs.coreutils pkgs.bash ] } &&
    true
  '';
}
