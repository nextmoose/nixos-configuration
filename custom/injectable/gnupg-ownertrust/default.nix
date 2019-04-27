{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation {
  name = "gnupg-ownertrust";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out/src &&
      chmod 0500 "$out/src/gnupg-ownertrust.sh" &&
      makeWrapper \
        "$out/src/gnupg-ownertrust.sh" \
	"$out/bin/gnupg-ownertrust" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.gnupg ]}" \
	--set STORE_DIR "$out/src" &&
      true
  '';
}