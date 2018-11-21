{
  pkgs ? import <nixpkgs> {},
    version ? "11.2.0",
    architecture ? "linux-x64",
    sha512 ? "1pchax0s70ckwcq35pj2c89iv3pdkk9a7j9q429qnnn4g5dri772bjvy3mv2fcr4qkm1x3p8xn4s6icszxg3hsa1k6mpz73p4icq7z3"
}:
let url = "https://nodejs.org/dist/v${version}/node-v${version}-${architecture}.tar.xz";
pkgs.stdenv.mkDerivation rec {
  name = "node";
  src = pkgs.fetchurl {
    url = "${url}";
    sha512 = "${sha512}";
  };
  installPhase = "cp --recursive . $out";
}
