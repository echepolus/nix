{ config, pkgs, agenix, secrets, lib, ... }:

let
  user = "alexeykotomin";
  sshPath = if pkgs.stdenv.hostPlatform.isLinux then "/home/${user}/.ssh/id_ed25519"
            else "/Users/${user}/.ssh/id_ed25519";
  signKeyPath = if pkgs.stdenv.hostPlatform.isLinux then "/home/${user}/.gnupg/private-keys-v1.d/sign_github.key"
                else "/Users/${user}/.gnupg/private-keys-v1.d/sign_github.key";
in
{
  age = {
    identityPaths = [
      sshPath
    ];

    secrets = {
      "id_github" = {
        symlink = true;
        path = sshPath;
        file = "${secrets}/id_github.age";
        mode = "600";
        owner = user;
        group = "wheel";
      };

      "sign_github" = {
        symlink = false;
        path = signKeyPath;
        file = "${secrets}/sign_github.age";
        mode = "600";
        owner = user;
        group = "wheel";
      };
    };
  };
}
