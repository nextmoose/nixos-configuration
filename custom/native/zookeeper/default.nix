{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "zookeeper";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts lib $out &&
      chmod --recursive 0500 $out/scripts/. &&
      chmod --recursive 0400 $out/lib/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/zookeeper.sh \
	$out/bin/zookeeper \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.zookeeper pkgs.coreutils pkgs.gnugrep pkgs.gnused pkgs.which pkgs.bash pkgs.tree ]} \
	--set ZOOKEEPER_DIR "${pkgs.zookeeper}" \
	&&
      true
  '';
}

