{
  pkgs ? import <nixpkgs> {},
  atom-packages
}:
pkgs.stdenv.mkDerivation {
  name = "atom";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper pkgs.atom pkgs.git ];
  buildPhase = ''
    chmod 0500 scripts/*.sh &&
      mkdir atom &&
      export ATOM_HOME=atom &&
      export GIT_SSL_NO_VERIFY=true &&
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
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.atom pkgs.git pkgs.coreutils pkgs.bash pkgs.trash-cli   pkgs.glib.dev ] } &&
    true
  '';
}
