{ lib }:

self: super: {

  # Backpin tdlib to a version compatible with telega
  tdlibForTelega = super.tdlib.overrideAttrs (_: {
    version = "1.8.45";
    src = super.fetchFromGitHub {
      owner = "tdlib";
      repo = "td";
      rev = "521aed8e4";
      sha256 = "08pqqir0m0wkk2c5lpijb9gslv0wk7msvf0s6v9aczzwj18pq3jm";
    };
  });

  emacsPackagesFor = emacs:
    (super.emacsPackagesFor emacs).overrideScope (eself: esuper: {

      telega =
        esuper.telega.overrideAttrs (final: old:
          let
            usedTdlibVersion =
              builtins.getAttr "version" (
                lib.findFirst
                  (drv: drv.pname == "tdlib")
                  (throw "telega: tdlib not found in buildInputs")
                  final.buildInputs
              );
          in {
            version = "0.8.999";
            src = super.fetchFromGitHub {
              owner = "zevlg";
              repo = "telega.el";
              rev = "ff06f58364375c96477561f265e3dbf55a8ad231";
              sha256 = "0bircjqj2zm67zspsy2r76zygvkxq6y65f3bchlhhhj1rr19kalh";
            };

            buildInputs =
              builtins.map
                (drv:
                  if drv.pname == "tdlib"
                  then self.tdlibForTelega
                  else drv
                )
                old.buildInputs;

            nativeBuildInputs =
              (old.nativeBuildInputs or []) ++ [
                self.buildPackages.ripgrep
              ];

            postPatch = ''
              ${old.postPatch or ""}

              requiredTdlibVersion="$(rg -o -r '$1' 'tdlib_version=v(.*)$' etc/Dockerfile)"

              if [[ "$requiredTdlibVersion" != "${usedTdlibVersion}" ]]; then
                echo "tdlib version mismatch: ${usedTdlibVersion} != $requiredTdlibVersion"
                exit 1
              fi
            '';
          });
    });
}
