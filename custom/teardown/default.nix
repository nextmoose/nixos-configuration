{
  pkgs,
  uuids
} :
let
  json = builtins.toJSON(uuids);
in
pkgs.stdenv.mkDerivation {
  name = "teardown";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive . $out/src &&
      chmod 0500 $out/src/teardown.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/src/teardown.sh \
	$out/bin/teardown \
	--set PATH "${pkgs.lib.makeBinPath [ pkgs.docker pkgs.jq ]}" \
	--set STORE_DIR "$out" &&
      echo '${json}' > "$out/uuids.json" &&
      true
  '';
}