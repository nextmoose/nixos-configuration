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
  init-read-write-pass-image = (import ./docker-image.nix {
    pkgs = pkgs;
    name = "init-read-write-pass";
    entrypoint = "${staples.init-read-write-pass}/bin/init-read-write-pass";
  });
  pass-image = (import ./docker-image.nix {
    pkgs = pkgs;
    name = "pass";
    entrypoint = "${pkgs.pass}/bin/pass";
    contents = [
      pkgs.cacert
    ];
  });
}