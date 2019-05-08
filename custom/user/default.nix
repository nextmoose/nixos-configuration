{
  pkgs,
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
  dependencies = [
    pkgs.docker
    docker-image-id
    pkgs.mktemp
    pkgs.findutils
    pkgs.coreutils
  ];
in
{
  setup = (import ./setup/default.nix {
    pkgs = pkgs;
    read-only-pass-image = read-only-pass-image;
    read-only-pass-image-uuid = read-only-pass
    system-secrets-read-only-pass-container-uuid = system-secrets-read-only-pass-container-uuid;
  });
  teardown = (import ./teardown/default.nix {
    pkgs = pkgs;
    read-only-pass-image = read-only-pass-image;
    system-secrets-read-only-pass-container = system-secrets-read-only-pass-container;
  });
  system-secrets-read-only-pass = (import ./pass/default.nix {
    pkgs = pkgs;
    name = "system-secrets-read-only-pass";
    uuid = system-secrets-read-only-pass-uuid;
    docker-container-id = docker-container-id;
  });
}