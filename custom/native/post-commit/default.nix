{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "post-commit";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/post-commit.sh \
	$out/bin/post-commit \
  --set GIT_EXEC_PATH "" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.git pkgs.coreutils ]} &&
      true
  '';
}
