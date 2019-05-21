{
   pkgs,
   init-gnupg,
   gnupg-key-id
}:
pkgs.stdenv.mkDerivation {
   name = "foo";
   src = ./src;
   buildInputs = [ pkgs.makeWrapper init-gnupg gnupg-key-id pkgs.coreutils pkgs.bash pkgs.pass pkgs.ca-cert ];
   installPhase = ''
      mkdir $out &&
	cp --recursive . "$out/src" &&
	chmod 0500 "$out/src/foo.sh" &&
	mkdir "$out/bin" &&
	mkdir "$out/home" &&
	export HOME="$out/home" &&
	init-gnupg &&
    	pass init $(gnupg-key-id) &&
    	pass git init &&
    	pass git remote add origin https://github.com/nextmoose/secrets.git &&
    	pass git fetch origin master &&
    	pass git config http.sslVerify false &&
    	pass git checkout origin/master &&
	makeWrapper \
	  "$out/src/foo.sh" \
	  "$out/bin/foo" \
	  --set HOME "$out/home" &&
	  --set PATH "${pkgs.lib.makeBinPath [ init-gnupg gnupg-key-id pkgs.coreutils pkgs.mktemp pkgs.bash pkgs.pass ] }" \
	  --set STORE_DIR "$out" &&
        true
   '';
}
