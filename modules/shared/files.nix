{ pkgs, config, ... }:

let
 githubPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYd53skWAuA7zkxSokdwrfAOjyHugQ5ZvRyUoyc/Rdk github-ssh-key";
in
{

  ".ssh/id_github.pub" = {
    text = githubPublicKey;
  };

  # Initializes Emacs with org-mode so we can tangle the main config
  ".emacs.d/init.el" = {
    text = builtins.readFile ./config/emacs/init.el;
  };

  # Emacs configuration in org-mode format
  ".config/emacs/config.org" = {
    text = builtins.readFile ./config/emacs/config.org;
  };
}
