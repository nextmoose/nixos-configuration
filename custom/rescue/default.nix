{
	pkgs ? import <nixpkgs> {},
	pass
}:
let
  dependencies = [
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
in
pkgs.stdenv.mkDerivation {
	name = "rescue";
	src = ./src;
	buildInputs = [ pkgs.makeWrapper ];
	installPhase = ''
	  mkdir $out &&
	    cp --recursive . $out/src &&
	    chmod \
	      0500 \
	      $out/src/install-nixos.sh &&
	    mkdir $out/bin &&
	    makeWrapper \
	      "$out/src/install-nixos.sh" \
	      "$out/bin/rescue-install-nixos" \
	      --set PATH "${pkgs.lib.makeBinPath dependencies}" \
              --set STORE_DIR "$out" &&
	    true
	'';
}