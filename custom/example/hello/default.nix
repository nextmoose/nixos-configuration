{}:
let
  native-derivation = (import ../../utils/native-derivation.nix);
in
native-derivation {
  name = "hello";
  src = ./src;
  wrappers = {out, pkgs}: "pkgs.makeWrapper $out/scripts/hello.sh $out/scripts.hello";
}
