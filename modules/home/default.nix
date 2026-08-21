{ ... }:

{
  imports = [
    ./packages
    ./shell
    ./terminal
    ./vcs/git.nix
  ];

  home.username = "yumx";
  home.homeDirectory = /Users/yumx;
  home.stateVersion = "26.05";
}
