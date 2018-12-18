{
  pkgs ? import <nixpkgs> {},
  pass
}
pkgs.stdenv.mkderivation {
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
     mkdir $out &&
       cp --recursive scripts $out &&
       chmod 0500 $out/scripts/*.sh &&
       mkdir $out/bin &&
       makeWrapper \
         $out/scripts/emacs.sh \
	 $out/bin/emacs \
	--set PATH ${pkgs.lib.makeBinPath [ pass pkgs.coreutils pkgs.git ]}
       true
  '';
}