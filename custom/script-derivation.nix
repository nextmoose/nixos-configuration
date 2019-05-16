{
   pkgs,
   name,
   src,
   dependencies ? [],
   configuration ? {}
}:
pkgs.stdenv.mkDerivation {
   name = name;
   src = src;
   buildInputs = [ pkgs.makeWrapper ];
   installPhase = ''
      mkdir $out &&
        cp --recursive "$out/src/${name}" "$out/script.sh" &&
	chmod 0500 "$out/script.sh" &&
	mkdir "$out/bin" &&
	makeWrapper \
	  "$out/script.sh" \
	   "$out/bin/${name}" \
	   --set PATH "${pkgs.lib.makeBinPath dependencies}" \
	   --set SOURCE_DIR "$out" \
           --set STORE_DIR "$out/src" &&
	echo '${builtins.toJSON configuration}' > "$out/configuration.json" &&
      true
   '';
}
