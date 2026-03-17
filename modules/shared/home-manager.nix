{ config, pkgs, lib, ... }:

let
    name = "echepolus";
    user = "alexeykotomin";
    email = "a.kotominn@gmail.com";
in
{
  direnv = {
    enable = true;
    enableBashIntegration = true;
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

      export PKG_CONFIG="$HOME/.nix-profile/bin/pkg-config"
      export PKG_CONFIG_PATH="$HOME/.nix-profile/lib/pkgconfig:$HOME/.nix-profile/share/pkgconfig:$HOME/.nix-profile/lib"
      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Ripgrep alias
      alias search='rg -p --glob "!node_modules/*" --glob "!vendor/*" "$@"'

      export ALTERNATE_EDITOR=""
      export EDITOR="emacsclient -t '$@'"
      export VISUAL="emacsclient -c -a emacs"
      # export EDITOR="/Users/alexeykotomin/.nix-profile/bin/nvim"
      # export VISUAL="/Users/alexeykotomin/.nix-profile/bin/nvim"
      e() {
          emacsclient -t "$@"
      }

      export NVIM="/Users/alexeykotomin/.nix-profile/bin/nvim"  

      [ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      [ -f ${pkgs.fzf}/share/fzf/completion.zsh ] && source ${pkgs.fzf}/share/fzf/completion.zsh
      
      export FZF_CTRL_T_OPTS="--height 60% \
      --border sharp \
      --layout reverse \
      --prompt '∷ ' \
      --pointer ▶ \
      --marker ⇒ \
      --preview '(bat --paging=never --color=always --style=plain --theme-base16 {} 2>/dev/null || tree -C {}) 2> /dev/null | head -200'"

      export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
      export FZF_COMPLETION_TRIGGER='**'
      export FZF_DEFAULT_OPTS="--bind=tab:accept"

      bindkey '^[c' fzf-cd-widget
      bindkey '^R' fzf-history-widget
      bindkey '^T' fzf-file-widget
      
      _fzf_complete_git() {
        _fzf_complete -- "$@" < <(
          git --help -a | grep -E '^\s+' | awk '{print $1}'
        )
      }

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

      export TERM=xterm-256color

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
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
      zstyle ':fzf-tab:*' fzf-bindings 'btab:toggle'
    '';
  };

  bash = {
        enable = true;
    enableCompletion = true;

    shellAliases = {
      search = "rg -p --glob '!node_modules/*' --glob '!vendor/*'";
      nr = "cd /Users/alexeykotomin/.config/nix && nix run .#build-switch";

      diff = "difft";
      ls = "ls -la --color=auto";

      ga = "git add .";
      gs = "git status";
      gd = "git diff";
      gdc = "git diff --cached";
    };

    initExtra = ''
      # nix
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # PATH
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.composer/vendor/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.local/share/src/conductly/bin:$PATH
      export PATH=$HOME/.local/share/src/conductly/utils:$PATH

      export PYTHONPATH="$HOME/.local-pip/packages:$PYTHONPATH"
      export CONFIG_DIR="$HOME/.config:$CONFIG_DIR"

      export HISTIGNORE="pwd:ls:cd"

      export EDITOR="emacsclient -t"
      export VISUAL="emacsclient -c -a emacs"

      export TERM=xterm-256color

      export NVIM="$HOME/.nix-profile/bin/nvim"

      # functions

      gc() {
        git commit -m "$*"
      }

      e() {
        emacsclient -t "$@"
      }

      shell() {
        nix-shell '<nixpkgs>' -A "$1"
      }

      # yazi cwd integration
      y() {
        local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
        yazi "$@" --cwd-file="$tmp"
        local cwd="$(cat "$tmp")"
        if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
          cd "$cwd"
        fi
        rm -f "$tmp"
      }

      # fzf
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
      source ${pkgs.fzf}/share/fzf/completion.bash

      # fzf settings
      export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border"

      # zoxide
      eval "$(${pkgs.zoxide}/bin/zoxide init bash)"

      # direnv
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"

      # brew (optional)
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      # rbenv (optional)
      if command -v rbenv >/dev/null; then
        eval "$(rbenv init - bash)"
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
