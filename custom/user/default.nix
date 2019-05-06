{
  pkgs,
  read-write-pass,
  read-only-pass,
  pass,
  docker-image-id,
  docker-container-id
} :
let
  read-only-pass-image-uuid = "5c6872cb-5274-4292-8894-514afe182845";
  read-write-pass-image-uuid = "e553b626-3ef8-470c-8d00-5dd7e1da77a9";
  system-secrets-read-only-container-uuid = "2a9f1b25-4c9e-4a4d-99a9-e31cdbcfe1b4";
  system-secrets-read-write-container-uuid = "7419053a-804d-4ee3-b754-c4e4bdd50ca9";
  read-only-pass-image = (import ./build-image.nix {
    pkgs = pkgs;
    name = "read-only-pass";
    entrypoint = "${read-only-pass}/bin/read-only-pass";
    contents = [
      pkgs.pass
    ];
    uuid = read-only-pass-image-uuid;
  });
  read-write-pass-image = (import ./build-image.nix {
    pkgs = pkgs;
    name = "read-write-pass";
    entrypoint = "${read-write-pass}/bin/read-write-pass";
    contents = [
      pkgs.pass
    ];
    uuid = read-write-pass-image-uuid;
  });
  dependencies = [
    pkgs.docker
    docker-image-id
    pkgs.mktemp
    pkgs.findutils
    pkgs.coreutils
  ];
in
pkgs.stdenv.mkDerivation {
  name = "user-setup";
  src = ./src;
   buildInputs = [
     pkgs.makeWrapper
   ];
   installPhase = ''
      mkdir "$out" &&
      mkdir "$out/images" &&
      cp "${read-only-pass-image}" "$out/images/read-only-pass.tar" &&
      cp --recursive . "$out/src" &&
      chmod \
        0500 \
	$out/src/user-setup.sh \
	$out/src/user-teardown.sh \
	$out/src/system-secrets-read-only-pass.sh \
	$out/src/system-secrets-read-write-pass.sh \
	&&
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/user-setup.sh" \
	"$out/bin/user-setup" \
	--set PATH "${pkgs.lib.makeBinPath dependencies }" \
	--set READ_ONLY_PASS_IMAGE_UUID "$read-only-pass-image-uuid" \
	--set SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID "$system-secrets-read-only-container-uuid" \
	--set SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID "$system-secrets-read-write-container-uuid" \
        --set STORE_DIR "$out" &&
      makeWrapper \
        "$out/src/user-teardown.sh" \
	"$out/bin/user-teardown" \
	--set READ_ONLY_PASS_IMAGE_UUID "$read-only-pass-image-uuid" \
	--set SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID "$system-secrets-read-only-container-uuid" \
	--set SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID "$system-secrets-read-write-container-uuid" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.docker docker-container-id ]}" &&
      makeWrapper \
        "$out/src/system-secrets-read-only-pass.sh" \
        "$out/bin/system-secrets-read-only-pass" \
	--set SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID "$system-secrets-read-only-container-uuid" \
        --set PATH "${pkgs.lib.makeBinPath [ pass ] }" &&
      makeWrapper \
        "$out/src/system-secrets-read-write-pass.sh" \
        "$out/bin/system-secrets-read-write-pass" \
	--set SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID "$system-secrets-read-write-container-uuid" \
        --set PATH "${pkgs.lib.makeBinPath [ pass ] }" &&
      true
   '';
}