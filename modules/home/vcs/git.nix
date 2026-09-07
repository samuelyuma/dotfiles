{
  config,
  lib,
  pkgs,
  ...
}:

let
  secretsYaml = ../../../secrets/secrets.yaml;
  hasGitPat =
    builtins.pathExists secretsYaml && lib.hasInfix "git_pat" (builtins.readFile secretsYaml);
in
{
  programs.git = {
    enable = true;

    package = pkgs.git.override { osxkeychainSupport = false; };

    settings = {
      user = {
        name = "samuelyuma";
        email = "samuelyuma.117@gmail.com";
      };

      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        lg = "log --oneline --graph --decorate";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autoStash = true;
      credential.helper =
        if hasGitPat then
          "store --file ${config.home.homeDirectory}/.git-credentials"
        else
          "cache --timeout=86400";
    };
  };

  sops = lib.mkIf hasGitPat {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = secretsYaml;
    secrets."github/git_pat" = { };
    templates."git-credentials" = {
      path = "${config.home.homeDirectory}/.git-credentials";
      mode = "0400";
      content = "https://samuelyuma:${config.sops.placeholder."github/git_pat"}@github.com";
    };
  };
}
