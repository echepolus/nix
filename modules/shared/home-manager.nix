{ config, pkgs, lib, ... }:

let
    name = "echepolus";
    user = "alexeykotomin";
    email = "a.kotominn@gmail.com";
in
{
  direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  zsh = {
    enable = true;
    autocd = false;
    cdpath = [ "~/.local/share/src" ];
    plugins = [
      {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./config;
          file = "p10k.zsh";
      }
    ];
    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Save and restore last directory
      LAST_DIR_FILE="$HOME/.zsh_last_dir"
      
      # Save directory on every cd
      function chpwd() {
        echo "$PWD" > "$LAST_DIR_FILE"
      }
      
      # Restore last directory on startup
      if [[ -f "$LAST_DIR_FILE" ]] && [[ -r "$LAST_DIR_FILE" ]]; then
        last_dir="$(cat "$LAST_DIR_FILE")"
        if [[ -d "$last_dir" ]]; then
          cd "$last_dir"
        fi
      fi

      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.composer/vendor/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.local/share/src/conductly/bin:$PATH
      export PATH=$HOME/.local/share/src/conductly/utils:$PATH
      export PYTHONPATH="$HOME/.local-pip/packages:$PYTHONPATH"
      export CONFIG_DIR="$HOME/.config:$CONFIG_DIR"

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Ripgrep alias
      alias search='rg -p --glob "!node_modules/*" --glob "!vendor/*" "$@"'

      export ALTERNATE_EDITOR=""
      export EDITOR="emacsclient -t"
      export VISUAL="emacsclient -c -a emacs"
      # export EDITOR="/Users/alexeykotomin/.nix-profile/bin/nvim"
      # export VISUAL="/Users/alexeykotomin/.nix-profile/bin/nvim"
      e() {
          emacsclient -t "$@"
      }
      export NVIM="/Users/alexeykotomin/.nix-profile/bin/nvim"  

      [ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      [ -f ${pkgs.fzf}/share/fzf/completion.zsh ] && source ${pkgs.fzf}/share/fzf/completion.zsh

      bindkey '^[c' fzf-cd-widget
      bindkey '^R' fzf-history-widget
      bindkey '^T' fzf-file-widget  

      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }
      alias nr='cd /Users/alexeykotomin/.config/nix && nix run .#build-switch'

      alias diff=difft

      alias ls='ls -la --color=auto'

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      eval "$(zoxide init zsh)"
      alias cd="z"

      export TERM=xterm-ghostty

      alias ga='git add .' 
      alias gs='git status'
      alias gd='git diff'
      alias gdc='git diff --cached'
      gc() {
        git commit -m "$*"
      }

      autoload -Uz compinit
      compinit
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };

  bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
      if which rbenv > /dev/null; then 
        eval "$(rbenv init -)"
      fi
    '';
  };

  git = {
    enable = true;

    settings = {
      user = {
        name = name;
        email = email;
      };

      extraConfig = {
        init.defaultBranch = "main";
        gpg.format = "openpgp";
        # user.signingkey = "E6C38CC7A3EC02D5"; # work with vm
        user.signingkey = "8EF70D99CF2ACEE8"; # work with mac
        commit.gpgsign = true;

        core = {
          editor = "vim";
          autocrlf = "input";
        };
        pull.rebase = true;
        rebase.autoStash = true;
      };
    };
    ignores = [ "*.swp" ];
    lfs.enable = true;
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Users/${user}/.ssh/config_external"
      )
    ];
  };

  yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
