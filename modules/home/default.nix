{ ... }:

{
  imports = [
    ./packages.nix
    ./prompt.nix
    ./shell.nix
    ./terminal.nix
  ];

  home.username = "yumx";
  home.homeDirectory = /Users/yumx;
  home.stateVersion = "26.05";
}
