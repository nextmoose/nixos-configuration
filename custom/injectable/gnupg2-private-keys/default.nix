{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation {
  name = "gnupg2-private-keys";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out/src &&
      chmod 0500 "$out/src/gnupg2-private-keys.sh" &&
      makeWrapper \
        "$out/src/gnupg2-private-keys.sh" \
	"$out/bin/gnupg2-private-keys" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.gnupg ]}" \
	--set STORE_DIR "$out/src" &&
      true
  '';
}