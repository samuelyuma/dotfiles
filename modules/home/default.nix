{ ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
  ];

  home.username = "yumx";
  home.homeDirectory = /Users/yumx;
  home.stateVersion = "26.05";
}
