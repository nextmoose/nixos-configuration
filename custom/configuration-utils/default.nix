{ stdenv }:
rec {
  emory = {
  ...
  }:
  let
    foo = "bar";
  in
    stdenv.mkDerivation {
      name = "${foo}";
      src = ./src;
      installPhase = ''
        mkdir $out &&
	  true
      '';
    };
}