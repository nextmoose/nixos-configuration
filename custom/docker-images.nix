{
  pkgs,
  staples
}:
{
  init-read-only-pass-image = (import ./docker-image.nix {
    pkgs = pkgs;
    name = "init-read-only-pass";
    entrypoint = "${staples.init-read-only-pass}/bin/init-read-only-pass";
  });
}