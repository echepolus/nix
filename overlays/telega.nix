final: prev: {
  package-name = prev.tdlib.overrideAttrs (old: {
    version = "1.8.4";
    src = prev.fetchFromGitHub {
      owner = "tdlib";
      repo = "td";
      rev = "v1.8.4";
      sha256 = "sha256-hash"; 
    };
  });
}
