{ config, pkgs, agenix, secrets, ... }:

let user = "alexeykotomin"; in
{
  age.identityPaths = [
    "/Users/${user}/.ssh/id_ed25519"
  ];

  # Your secrets go here
  #
  # Note: the installWithSecrets command you ran to boostrap the machine actually copies over
  #       a Github key pair. However, if you want to store the keypair in your nix-secrets repo
  #       instead, you can reference the age files and specify the symlink path here. Then add your
  #       public key in shared/files.nix.
  #
  #       If you change the key name, you'll need to update the SSH configuration in shared/home-manager.nix
  #       so Github reads it correctly.

  
  age.secrets."id_github" = {
   symlink = true;
   path = "/Users/${user}/.ssh/id_github";
   file =  "${secrets}/id_github.age";
   mode = "600";
   owner = "${user}";
   group = "staff";
  };

  age.secrets."sign_github" = {
    symlink = false;
    path = "/Users/${user}/.gnupg/private-keys-v1.d/sign_github.key";
    file =  "${secrets}/sign_github.age";
    mode = "600";
    owner = "${user}";
  };

  age.secrets."darwin-syncthing-cert" = {
    path = "/Users/${user}/.config/syncthing/cert.pem";
    file = "${secrets}/darwin-syncthing-cert.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };

  age.secrets."darwin-syncthing-key" = {
    path = "/Users/${user}/.config/syncthing/key.pem";
    file = "${secrets}/darwin-syncthing-key.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };
}
