{ pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "gnucash";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out &&
      chmod 0400 $out/lib/* &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      makeWrapper \
        $out/scripts/gnucash.sh \
        $out/bin/gnucash \
        --set PATH ${pkgs.lib.makeBinPath [  pkgs.gnucash ]} &&
     true
  '';
};
