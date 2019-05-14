{
  pkgs,
  name,
  home,
  run,
  entrypoint
} :
pkgs.stdenv.mkDerivation {
  name = name;
  src = ./src;
  build-inputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir "$out" &&
      cp --recursive "$out/src" &&
      chmod 0500 "$out/src/entrypoint.sh" &&
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/entrypoint.sh" \
	"$out/bin/entrypoint" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.coreutils ]}" \
	--set HOME "${home}" \
	--set RUN "${run}" \
	--set ENTRYPOINT "${entrypoint}" \
      true
  '';
}