{
  pkgs,
  name,
  uuid,
  run,
  entrypoint,
  build-entrypoint
} :
pkgs.stdenv.mkDerivation {
  name = name;
  src = ./src;
  buildInputs = [ pkgs.makeWrapper entrypoint ];
  installPhase = ''
    mkdir "$out" &&
      cp --recursive . "$out/src" &&
      chmod 0500 "$out/src/entrypoint.sh" &&
      (cat > "$out/run.sh" <<EOF
${run}
EOF
      ) &&
      build-entrypoint "${entrypoint}" > "${out/entrypoint.sh" &&
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