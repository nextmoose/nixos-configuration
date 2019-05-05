{
  pkgs,
  staples
} :
let
  read-only-pass-image = (import ./build-image.nix {
    pkgs = pkgs;
    name = "read-only-pass";
    entrypoint = "${staples.read-only-pass}/bin/read-only-pass";
    contents = [
      pkgs.pass
    ];
  });
in
pkgs.stdenv.mkDerivation {
  name = "user-setup";
  src = ./src;
   buildInputs = [ pkgs.makeWrapper ];
   installPhase = ''
      mkdir "$out" &&
      mkdir "$out/images" &&
      cp "${read-only-pass-image}" "$out/images/read-only-pass.tar &&
      cp --recursive . "$out/src" &&
      mkdir "$out/bin" &&
      makeWrapper \
        $out/src/user-setup.sh \
	$out/bin/user-setup \
	--set PATH "${pkgs.lib.makeBinPath [pkgs.docker]}" \
        --set STORE_DIR "$out/src" &&
      true
   '';
}