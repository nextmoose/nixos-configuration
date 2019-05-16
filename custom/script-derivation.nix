{
   pkgs,
   name,
   src,
   dependencies ? [],
   binary-name ? name
   configuration ? {}
}:
pkgs.stdenv.mkDerivation {
   name = name;
   src = src;
   buildInputs = [ pkgs.makeWrapper ];
   installPhase = ''
      mkdir $out &&
        cp --recursive . "$out/src" &&
	chmod 0500 "$out/src/${name}.sh" &&
	mkdir "$out/bin" &&
	makeWrapper \
	  "$out/src/${name}.sh" \
	   "$out/bin/${binary-name}" \
	   --set PATH "${pkgs.lib.makeBinPath dependencies}" \
           --set STORE_DIR "$out/src" &&
	echo '${builtins.toJSON configuration} > "$out/configuration.json" &&
      true
   '';
}
