{
	pkgs ? import <nixpkgs> {},
	pass
}:
let dependencies = [
      pass
      pkgs.coreutils
      pkgs.git
      pkgs.gnugrep
      pkgs.gnused
      pkgs.gnutar
      pkgs.mkpasswd
      pkgs.mktemp
      pkgs.rsync
      pkgs.systemd
      pkgs.which
];
pkgs.stdenv.mkDerivation {
	name = "rescue";
	src = ./src;
	buildInputs = [ pkgs.makeWrapper ];
	installPhase = ''
	  mkdir $out &&
	    cp --recursive . $out/src &&
	    mkdir $out/bin &&
	    makeWrapper \
	      "$out/src/install-nixos.sh" \
	      "$out/bin/rescue-install-nixos" \
	      --set PATH "${pkgs.lib.makeBinPath []}" \
              --set STORE_DIR "$out" &&
	    true
	'';
}