{ config, pkgs, agenix, secrets, ... }:

let user = "alexeykotomin"; in
{
  age = { 
    identityPaths = [
      "/home/${user}/.ssh/id_ed25519"
    ];

    secrets = {
      "id_github" = {
        symlink = true;
        path = "/home/${user}/.ssh/id_github";
        file =  "${secrets}/id_github.age";
        mode = "600";
        owner = "${user}";
      };

      "sign_github" = {
        symlink = false;
        path = "/home/${user}/.gnupg/private-keys-v1.d/sign_github.key";
        file =  "${secrets}/sign_github.age";
        mode = "600";
        owner = "${user}";
      };
    };
  };
}
