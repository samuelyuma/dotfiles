{ ... }:

{
  imports = [ ../../modules/darwin ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "yumx";
  system.stateVersion = 6;

  users.users.yumx.home = /Users/yumx;
}
