{ ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "check";

    casks = [
      "arc"
      "cc-switch"
      "chatgpt"
      "cloudflare-warp"
      "codex"
      "discord"
      "ghostty"
      "google-chrome"
      "handbrake-app"
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
      "zcode"
      "zed"
      "zoom"
    ];
  };
}
