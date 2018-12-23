{
   pkgs ? import <nixpkgs> {},
   node ? pkgs.node,
   name,
   src
}:
pkgs.stdenv.mkDerivation {
   name = name;
   src = src;
   buildInputs = [ node ];
   installPhase = ''
     cp --recursive . $out &&
       cd $out &&
       npm install &&
       # ln --symbolic $out/node_modules/.bin $out/bin &&
       true
   '';
}