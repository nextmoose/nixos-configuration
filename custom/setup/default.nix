{
  pkgs,
  docker-image-id,
  docker-container-id,
  uuids
} :
let
  json = builtins.toJSON uuids;
in
pkgs.stdenv.mkDerivation {
  name = "setup";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . "$out/src" &&
      chmod 0500 "$out/src/setup.sh" &&
      mkdir "$out/bin" &&
      cp json "$out/uuids.json" &&
      makeWrapper \
        "$out/src/setup.sh" \
	"$out/bin/setup" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.docker docker-image-id docker-container-id] }" \
	--set STORE_DIR "$out" &&
     true
  '';
}