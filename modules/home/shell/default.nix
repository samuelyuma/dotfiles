{ config, pkgs, ... }:

{
  home.sessionPath = [
    "/etc/profiles/per-user/yumx/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.opencode/bin"
  ];

  programs.starship.settings = builtins.fromTOML (builtins.readFile ./starship.toml);

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      v = "nvim";
      vi = "nvim";
      cls = "clear";
      ls = "eza --color=always --icons";
      l = "eza -l --icons";
      la = "eza -la --icons";
      lla = "eza -la --icons";
      lt = "eza --tree --icons";
      cat = "bat -p";
      rcat = "/bin/cat";
      grep = "grep --color=auto";
      df = "df -h";
      du = "du -h";
      cp = "cp -iv";
      mv = "mv -iv";
      mkdir = "mkdir -pv";
      cd = "z";
      cdi = "zi";
      path = "print -l $path";

      zshconf = "nano ${config.home.homeDirectory}/Code/config/dotfiles/modules/home/shell/default.nix";
      ghosttyconf = "nano ${config.home.homeDirectory}/Code/config/dotfiles/modules/home/terminal/ghostty.conf";

    };

    initContent = ''
      reload() {
        unset __HM_SESS_VARS_SOURCED __HM_ZSH_SESS_VARS_SOURCED
        export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
        exec /bin/zsh -l
      }

      ZINIT_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
      zstyle ':zinit:config' home-dir "$ZINIT_HOME"
      source "${pkgs.zinit}/share/zinit/zinit.zsh"

      zinit snippet OMZL::git.zsh
      zinit snippet OMZP::git
      zinit snippet OMZ::plugins/uv/uv.plugin.zsh
      zinit snippet OMZ::plugins/bun/bun.plugin.zsh
      zinit snippet OMZ::plugins/docker/docker.plugin.zsh

      zinit ice blockf atload"zicompinit; zicdreplay"
      zinit light zsh-users/zsh-completions
      zinit light Aloxaf/fzf-tab
      zinit light zsh-users/zsh-autosuggestions
      zinit light zsh-users/zsh-history-substring-search
      zinit light zsh-users/zsh-syntax-highlighting

      unalias zi 2>/dev/null || true
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

      export BAT_THEME="base16"

      if command -v pyenv >/dev/null 2>&1; then
        eval "$(pyenv init -)"
      fi

      if command -v fnm >/dev/null 2>&1; then
        eval "$(fnm env --use-on-cd --shell zsh)"
      fi

    '';
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidget.command = "fd --type f --hidden --follow --exclude .git";
    changeDirWidget.command = "fd --type d --hidden --follow --exclude .git";
    historyWidget.command = "";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
  };
}
