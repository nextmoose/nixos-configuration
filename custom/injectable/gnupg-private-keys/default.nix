{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation {
  name = "gnupg-private-keys";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out/src &&
      chmod 0500 "$out/src/gnupg-private-keys.sh" &&
      makeWrapper \
        "$out/src/gnupg-private-keys.sh" \
	"$out/bin/gnupg-private-keys" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.gnupg ]}" \
	--set STORE_DIR "$out" &&
      true
  '';
}