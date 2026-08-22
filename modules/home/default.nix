_:

{
  imports = [
    ./editor
    ./packages
    ./shell
    ./terminal
    ./vcs/git.nix
  ];

  home = {
    username = "yumx";
    homeDirectory = /Users/yumx;
    stateVersion = "26.05";
  };
}
