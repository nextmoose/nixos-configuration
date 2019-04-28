{
  pkgs,
  staples
}:
{
  system-secrets-read-only-pass-image = (import ./docker-image.nix {
    pkgs = pkgs;
    name = "system-secrets-read-only-pass";
    entrypoint = ''
      ${staples.init-read-only-pass}/bin/init-read-only-pass \
        --remote https://github.com/nextmoose/secrets.git \
	--branch master &&
	${pkgs.pass}/bin/pass
    '';
  });
}