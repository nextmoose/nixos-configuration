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
  buildInputs = [ pkgs.makeWrapper entrypoint ];
  installPhase = ''
    mkdir "$out" &&
      echo AAAAA 00100 &&
      cp --recursive . "$out/src" &&
      echo AAAAA 00200 &&
      chmod 0500 "$out/src/entrypoint.sh" &&
      echo AAAAA 00300 &&
      (cat > "$out/run.sh" <<EOF
${run}
EOF
      ) &&
      echo AAAAA 00400 &&
      echo "${entrypoint} " > "$out/entrypoint.sh" &&
      echo AAAAA 00500 &&
      cat "$out/src/at.txt" >> "$out/entrypoint.sh" &&
      echo AAAAA 00600 &&
      mkdir "$out/bin" &&
      echo AAAAA 00700 &&
      makeWrapper \
        "$out/src/entrypoint.sh" \
	"$out/bin/${name}" \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.bash ]}" \
	--set STORE_DIR "$out" \
	--set UUID "${uuid}" &&
      true
  '';
}