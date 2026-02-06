self: super: with super;{

  # Add our Emacs packages to the fixpoint
  emacsPackagesFor = emacs: (
    (super.emacsPackagesFor emacs).overrideScope (eself: esuper: {
      
      checkedTelega =
        esuper.telega.overrideAttrs (finalAttrs: oldAttrs:
          let
            usedTdlibVersion = builtins.getAttr "version" (
              lib.findFirst (drv: drv.pname == "tdlib")
                (throw "BUG: checkedTelega: could not find tdlib in buildInputs")
                finalAttrs.buildInputs
            );
          in
          {
            version = "0.8.999"; # unstable
            src = self.fetchFromGitHub {
              owner = "zevlg";
              repo = "telega.el";
              rev = "ff06f58364375c96477561f265e3dbf55a8ad231";
              sha256 = "0bircjqj2zm67zspsy2r76zygvkxq6y65f3bchlhhhj1rr19kalh";
            };

            buildInputs = builtins.map
              (drv: if drv.pname == "tdlib" then self.tdlibForTelega else drv)
              oldAttrs.buildInputs;

            nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
              self.buildPackages.ripgrep
            ];

            postPatch = ''
              ${oldAttrs.postPatch or ""}

              requiredTdlibVersion="$(rg -o -r '$1' 'tdlib_version=v(.*)$' etc/Dockerfile)"

              if [[ "$requiredTdlibVersion" != "${usedTdlibVersion}" ]]; then
                  echo "nixpkgs or tvl overlay tdlib version (${usedTdlibVersion}) doesn't match expected $requiredTdlibVersion"
                  echo "ping tazjin if you see this message"
                  exit 1
              fi
            '';
          }
        );
    })
  );

  # Backpin tdlib to match telega (which doesn't support the latest version of
  # tdlib yet), reverting https://github.com/NixOS/nixpkgs/pull/388066
  tdlibForTelega = self.tdlib.overrideAttrs (_: {
    version = "1.8.45";
    src = self.fetchFromGitHub {
      owner = "tdlib";
      repo = "td";
      rev = "521aed8e4";
      sha256 = "08pqqir0m0wkk2c5lpijb9gslv0wk7msvf0s6v9aczzwj18pq3jm";
    };
  });
}
