{
  pkgs,
  docker-image-id,
  docker-container-id,
  uuids,
  read-only-pass
} :
let
  json = builtins.toJSON uuids;
  read-only-pass-image = (import ./build-image.nix {
    pkgs = pkgs;
    name = "read-only-pass";
    entrypoint = "${read-only-pass}/bin/read-only-pass";
    contents = [
      pkgs.pass
    ];
    uuid = uuids.images.read-only-pass;
  });
in
pkgs.stdenv.mkDerivation {
  name = "setup";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . "$out/src" &&
      chmod 0500 "$out/src/setup.sh" &&
      echo '${json}' > "$out/uuids.json" &&
      mkdir "$out/images" &&
      ln --symbolic "${read-only-pass-image}" "$out/images/read-only-pass.tar" &&
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/setup.sh" \
	"$out/bin/setup" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.docker docker-image-id docker-container-id pkgs.jq ] }" \
	--set STORE_DIR "$out" &&
     true
  '';
}