{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "foo";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/execstart.sh \
	      $out/bin/execstart \
	      --set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils ]} &&
        makeWrapper \
          $out/scripts/execstop.sh \
  	      $out/bin/execstop \
  	      --set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils ]} &&
      true
  '';
}
