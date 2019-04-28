{
  pkgs,
  staples
}:
{
  init-read-only-pass-image = (import ./docker-image.nix {
    pkgs = pkgs;
    name = "system-secrets-read-only-pass";
    contents = [
      staples.init-read-only-pass
      pkgs.pass
    ];
    entrypoint = "${staples.init-read-only-pass}/bin/init-read-only-pass";
  });
}