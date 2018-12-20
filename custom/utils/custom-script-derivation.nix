{
   pkgs ? import <nixpkgs> {},
   name,
   src,
   dependencies
}:
pkgs.stdenv.mkDerivation {
   name = name;
   src = src;
   buildInputs = [ pkgs.makeWrapper ];
   installPhase = ''
      mkdir $out &&
        mkdir $out/scripts &&
	cp . $out/scripts/${name}.sh &&
	chmod 0500 $out/scripts/${name}.sh &&
	makeWrapper \
	  $out/scripts/${name}.sh \
	  $out/bin/${name} \
	   --set PATH ${pkgs.lib.makeBinPath [ ] }
   '';
}