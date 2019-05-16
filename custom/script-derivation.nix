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
   buildPhase = ''
     chmod 0500 ./${name}.sh &&
       true
   '';
   installPhase = ''
      mkdir $out &&
	mkdir "$out/bin" &&
	makeWrapper \
	  "${src}/${name}.sh" \
	   "$out/bin/${name}" \
	   --set PATH "${pkgs.lib.makeBinPath dependencies}" \
	   --set SOURCE_DIR "${src}" \
           --set STORE_DIR "$out" &&
	echo '${builtins.toJSON configuration}' > "$out/configuration.json" &&
      true
   '';
}
