{
   pkgs,
   name,
   src,
   dependencies ? [],
   configuration ? {},
   test-script
}:
rec {
  implementation = (import ./script-implementation-derivation.nix {
    pkgs = pkgs;
    name = name;
    src = src;
    dependencies = dependencies;
    configuration = configuration;
  });
  testing = rec {
    instrument = (import ./script-test.nix {
      implementation = implementation;
      test-script = test-script;
    });
    results = instrument {
      pkgs = pkgs;
    };
  };
}