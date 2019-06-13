{
   pkgs,
   name,
   src,
   dependencies ? [],
   configuration ? {},
   test-script
}: {
  impl = (import ./script-implementation-derivation.nix {
    pkgs = pkgs;
    name = name;
    src = src;
    dependencies = dependencies;
    configuration = configuration;
  });
}