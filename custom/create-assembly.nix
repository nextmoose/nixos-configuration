
{
   pkgs ? import <nixpkgs> {},
   name,
   src,
   dependencies ? []
}:
pkgs.stdenv.mkDerivation {
   name = name;
   src = src;
   buildInputs = [ pkgs.makeWrapper ];
   installPhase = ''
      mkdir $out &&
	      cp --recursive . $out &&
	      chmod 0500 $out/usr/src/${name}.sh &&
	      makeWrapper \
	        $out/usr/src/${name}.sh \
	        $out/bin/${name} \
	        --set PATH ${pkgs.lib.makeBinPath dependencies } \
          --set STORE_DIR $out &&
      true
   '';
}
