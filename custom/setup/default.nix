{
  pkgs,
  docker-image-id,
  docker-container-id,
  uuids,
  uuid-parser,
  read-only-pass,
  read-write-pass,
  docker-health-check,
  docker-container-start-and-wait-for-healthy,
  start-read-only-pass-container
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
    docker-health-check = docker-health-check;
  });
  read-write-pass-image = (import ./build-image.nix {
    pkgs = pkgs;
    name = "read-write-pass";
    entrypoint = "${read-write-pass}/bin/read-write-pass";
    contents = [
      pkgs.pass
    ];
    uuid = uuids.images.read-write-pass;
    docker-health-check = docker-health-check;
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
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/setup.sh" \
	"$out/bin/setup" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.docker docker-image-id docker-container-id uuid-parser pkgs.findutils docker-container-start-and-wait-for-healthy start-read-only-pass-container ] }" \
	--set STORE_DIR "$out" &&
      echo '${json}' > "$out/uuids.json" &&
      mkdir "$out/images" &&
      ln --symbolic "${read-only-pass-image}" "$out/images/read-only-pass.tar" &&
      ln --symbolic "${read-write-pass-image}" "$out/images/read-write-pass.tar" &&
      true
  '';
}