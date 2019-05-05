{
  pkgs,
  staples
} :
let
  read-only-pass-image = (import ./build-image.nix {
    pkgs = pkgs;
    name = "read-only-pass";
    entrypoint = "${staples.read-only-pass}/bin/read-only-pass";
    contents = [
      pkgs.pass
    ];
    uuid = "5c6872cb-5274-4292-8894-514afe182845";
  });
  dependencies = [
    pkgs.docker
    staples.docker-image-id
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
	--set READ_ONLY_PASS_IMAGE_UUID "5c6872cb-5274-4292-8894-514afe182845" \
	--set SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID "2a9f1b25-4c9e-4a4d-99a9-e31cdbcfe1b4" \
	--set SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID "7419053a-804d-4ee3-b754-c4e4bdd50ca9" \
        --set STORE_DIR "$out" &&
      makeWrapper \
        "$out/src/user-teardown.sh" \
	"$out/bin/user-teardown" \
	--set READ_ONLY_PASS_IMAGE_UUID "5c6872cb-5274-4292-8894-514afe182845" \
	--set SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID "2a9f1b25-4c9e-4a4d-99a9-e31cdbcfe1b4" \
	--set SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID "7419053a-804d-4ee3-b754-c4e4bdd50ca9" &&
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.docker ]}" \
      makeWrapper \
        "$out/src/system-secrets-read-only-pass.sh" \
        "$out/bin/system-secrets-read-only-pass" \
	--set SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID "2a9f1b25-4c9e-4a4d-99a9-e31cdbcfe1b4" \
        --set PATH "${pkgs.lib.makeBinPath [ staples.pass ] }" &&
      makeWrapper \
        "$out/src/system-secrets-read-write-pass.sh" \
        "$out/bin/system-secrets-read-write-pass" \
	--set SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID "7419053a-804d-4ee3-b754-c4e4bdd50ca9" \
        --set PATH "${pkgs.lib.makeBinPath [ staples.pass ] }" &&
      true
   '';
}