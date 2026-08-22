_:

{
  programs.git = {
    enable = true;

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
      credential.helper = "osxkeychain";
    };
  };
}
