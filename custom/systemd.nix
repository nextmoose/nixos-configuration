{
  pkgs,
  staples
}:
{
  init-system-secrets-read-only-pass-container = (import ./docker-container.nix {
    pkgs = pkgs;
    name = "init-system-secrets-read-only-pass";
    image = "init-read-only-pass";
    arguments = ''
      --remote https://github.com/nextmoose/secrets.git \
      --branch master
    '';
  });
  init-read-only-pass-image = (import ./docker-image.nix {
    pkgs = pkgs;
    name = "init-read-only-pass";
    entrypoint = "${staples.init-read-only-pass}/bin/init-read-only-pass";
  });
}