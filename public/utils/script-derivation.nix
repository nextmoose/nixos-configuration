{
   pkgs,
   name,
   implementation,
   test-script,
   dependencies ? [],
   configuration ? {},
}:
rec {
  impl = pkgs.stdenv.mkDerivation {
     name = name;
     src = implementation;
     buildInputs = [ pkgs.makeWrapper ];
     installPhase = ''
        mkdir $out &&
 	  cp --recursive . "$out/src" &&
	  chmod 0500 "$out/src/${name}.sh" &&
	  mkdir "$out/bin" &&
	  makeWrapper \
	    "$out/src/${name}.sh" \
	    "$out/bin/${name}" \
	    --set PATH "${pkgs.lib.makeBinPath dependencies}" \
	    --set STORE_DIR "$out" &&
	  echo '${builtins.toJSON configuration}' > "$out/configuration.json" &&
          true
     '';
  };
  test = import <nixpkgs/nixos/tests/make-test.nix> {
    machine = { pkgs, ... } : {
      users = {
        mutableUsers = false;
        extraUsers.user = {
          isNormalUser = true;
          uid = 1000;
          extraGroups = [ "wheel" ];
          packages = [
	    implementation
          ];
          password = "password";
        };
      };
    };
    testScript = (builtins.readFile test-script);
  };
}
