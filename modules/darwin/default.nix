{ pkgs, ... }:

{
  fonts.packages = [ pkgs.nerd-fonts.geist-mono ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    casks = [
      "arc"
      "chatgpt"
      "codex"
      "discord"
      "ghostty"
      "google-chrome"
      "helium-browser"
      "macs-fan-control"
      "markdown-preview"
      "microsoft-word"
      "notion"
      "opencode-desktop"
      "spotify"
      "steam"
      "tailscale-app"
      "telegram"
      "the-unarchiver"
      "whatsapp"
      "zed"
      "zoom"
    ];
  };
}
