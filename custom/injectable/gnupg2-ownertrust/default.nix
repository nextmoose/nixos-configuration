{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation {
  name = "gnupg2-ownertrust";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out/src &&
      chmod 0500 "$out/src/gnupg2-ownertrust.sh" &&
      makeWrapper \
        "$out/src/gnupg2-ownertrust.sh" \
	"$out/bin/gnupg2-ownertrust" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.gnupg ]}" \
	--set STORE_DIR "$out" &&
      true
  '';
}