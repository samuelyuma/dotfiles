{ ... }:

{
  programs.starship.settings = builtins.fromTOML (builtins.readFile ./starship.toml);

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

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

      reload = "exec zsh";
      zshconf = "nvim ~/.zshrc";
      ghosttyconf = "nvim ~/Library/Application Support/com.mitchellh.ghostty/config";

    };

    initContent = ''
      export BAT_THEME="base16"

      export PATH="/Library/TeX/texbin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.opencode/bin:$PATH"
      export PATH="$HOME/go/bin:$PATH"

      if command -v pyenv >/dev/null 2>&1; then
        eval "$(pyenv init -)"
      fi

      if command -v fnm >/dev/null 2>&1; then
        eval "$(fnm env --use-on-cd --shell zsh)"
      fi

      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
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
    enableZshIntegration = true;
  };
}
