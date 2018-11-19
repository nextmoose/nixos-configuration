{}:
let
  native-derivation = (import ../../utils/native-derivation.nix);
in
native-derivation {
  name = "hello";
  src = ./src;
  wrappers = [
    {
      script = "hello.sh";
      bin = "hello";
    }
  ];
}
