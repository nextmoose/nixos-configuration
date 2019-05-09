{
  pkgs,
  name,
  uuid
} :
pkgs.stdenv.mkDerivation {
  name = name;
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . "$out/src" &&
        chmod 0500 "$out/src/secrets.sh" &&
	mkdir "$out/bin" &&
	makeWrapper \
	  "$out/src/secrets.sh" \
	  "$out/bin/${name}" \
	  --set UUID "${uuid}" \
	  --set PATH "${pkgs.lib.makeBinPath [ pkgs.docker  ]}" &&
       true
  '';
}