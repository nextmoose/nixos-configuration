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
        cp "./${name}.sh" "$out/script.sh" &&
	chmod 0500 "$out/script.sh" &&
	mkdir "$out/bin" &&
	makeWrapper \
	  "$out/script.sh" \
	   "$out/bin/${name}" \
	   --set PATH "${pkgs.lib.makeBinPath dependencies}" \
	   --set SOURCE_DIR "${src}" \
           --set STORE_DIR "$out" &&
	echo '${builtins.toJSON configuration}' > "$out/configuration.json" &&
      true
   '';
}
