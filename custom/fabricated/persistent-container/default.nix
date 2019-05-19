{
  pkgs,
  name,
  uuid,
  run,
  entrypoint
} :
pkgs.stdenv.mkDerivation {
  name = name;
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir "$out" &&
      cp --recursive . "$out/src" &&
      chmod 0500 "$out/src/entrypoint.sh" &&
      echo "${run}" > "$out/run.sh" &&
      echo -n "${entrypoint} " > "$out/entrypoint.sh" &&
      cat "$out/src/at.txt" >> "$out/entrypoint.sh" &&
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/entrypoint.sh" \
	"$out/bin/${name}" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.bash ]}" \
	--set STORE_DIR "$out" \
	--set UUID "${uuid}" &&
      true
  '';
}