{
  pkgs,
  name,
  src
}:
pkgs.stdenv.mkDerivation {
  name = name;
  src = src;
  buildInputs = [ ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . "$out/src" &&
      mkdir "$out/bin" &&
      makeWrapper \
        "$out/src/${name}.sh" \
	"$out/bin/${name}" \
	--set PATH "${pkgs.lib.makeBinPath dependencies}" \
	--set STORE_DIR "$out" &&
      echo '${builtins.toJSON configuration}' > "$out/configuration.json" &&
      true
   '';
}