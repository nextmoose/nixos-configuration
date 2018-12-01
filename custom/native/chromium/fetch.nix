{ url, rev ? "HEAD", md5 ? "", sha256 ? "", leaveDotGit ? deepClone
, fetchSubmodules ? true, deepClone ? false
, branchName ? null
, name ? urlToName url rev
, # Shell code executed after the file has been fetched
  # successfully. This can do things like check or transform the file.
  postFetch ? ""
}:
let
  depot_tools = (import ./depot_tools.nix {});
in
/* NOTE:
   fetchgit has one problem: git fetch only works for refs.
   This is because fetching arbitrary (maybe dangling) commits may be a security risk
   and checking whether a commit belongs to a ref is expensive. This may
   change in the future when some caching is added to git (?)
   Usually refs are either tags (refs/tags/*) or branches (refs/heads/*)
   Cloning branches will make the hash check fail when there is an update.
   But not all patches we want can be accessed by tags.

   The workaround is getting the last n commits so that it's likely that they
   still contain the hash we want.

   for now : increase depth iteratively (TODO)

   real fix: ask git folks to add a
   git fetch $HASH contained in $BRANCH
   facility because checking that $HASH is contained in $BRANCH is less
   expensive than fetching --depth $N.
   Even if git folks implemented this feature soon it may take years until
   server admins start using the new version?
*/

assert deepClone -> leaveDotGit;

if md5 != "" then
  throw "fetchgit does not support md5 anymore, please use sha256"
else
stdenvNoCC.mkDerivation {
  inherit name;
  builder = ./builder.sh;
  fetcher = "${./nix-prefetch-git}";  # This must be a string to ensure it's called with bash.
  nativeBuildInputs = [git];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev leaveDotGit fetchSubmodules deepClone branchName postFetch;

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  impureEnvVars = stdenvNoCC.lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND" "SOCKS_SERVER"
  ];

  preferLocalBuild = true;
}
