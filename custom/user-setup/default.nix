{
  pkgs,
  staples,
  system-secrets-read-only-pass-container-uuid,
  system-secrets-read-write-pass-container-uuid
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
      chmod 0500 "$out/src/user-setup.sh" &&
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/user-setup.sh" \
	"$out/bin/user-setup" \
	--set PATH "${pkgs.lib.makeBinPath dependencies }" \
	--set READ_ONLY_PASS_IMAGE_UUID "5c6872cb-5274-4292-8894-514afe182845" \
	--set SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID "${system-secrets-read-only-pass-container-uuid}" \
	--set SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID "${system-secrets-read-write-pass-container-uuid}" \
        --set STORE_DIR "$out" &&
      true
   '';
}