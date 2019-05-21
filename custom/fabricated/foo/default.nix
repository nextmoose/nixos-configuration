{
   pkgs,
   init-gnupg
   gnupg-key-id
}:
pkgs.stdenv.mkDerivation {
   name = "foo";
   src = ./src;
   buildInputs = [ pkgs.makeWrapper ];
   installPhase = ''
      mkdir $out &&
	cp --recursive . "$out/src" &&
	chmod 0500 "$out/src/foo.sh" &&
	mkdir "$out/bin" &&
	makeWrapper \
	  "$out/src/foo.sh" \
	  "$out/bin/foo" \
	  --set PATH "${pkgs.lib.makeBinPath [ init-gnupg gnupg-key-id kgs.coreutils pkgs.mktemp pkgs.bash ] }" \
	  --set STORE_DIR "$out" &&
        true
   '';
}
