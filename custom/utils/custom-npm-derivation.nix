{
   pkgs ? import <nixpkgs> {},
   node ? pkgs.node,
   name,
   src,
   dependencies
}:
pkgs.stdenv.mkDerivation {
   name = name;
   src = src;
   buildInputs = [ node ];
   buildPhase = ''
     npm install &&
       true
   '';
   installPhase = ''
     cp --recursive . $out &&
       ln --symbolic $out/node_modules/.bin $out/bin &&
       true
   '';
}