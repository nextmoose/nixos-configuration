{
   pkgs ? import <nixpckgs> {},
   name,
   src,
   dependencies
}:
pkgs.stdenv.mkDerivation {
   name = ${name};
   src = ${src};
   buildInputs = [ pkgs.makeWrapper ];
   installPhase = ''
      mkdir $out &&
        cp --recursive . $out &&
	chmod 0500 $out/scripts/*.sh &&
	makeWrapper \
	  $out/scripts/${name}.sh \
	  $out/bin/${name} \
	   --set PATH ${pkgs.lib.makeBinPath ${dependencies} }
   '';
}