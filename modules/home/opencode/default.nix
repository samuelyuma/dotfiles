{
  config,
  lib,
  pkgs,
  ...
}:

let
  zenFreeModels = [
    "opencode/muse-spark-1.3-contributor-free"
    { model = "opencode/muse-spark-1.2-contributor-free"; }
    { model = "opencode/nemotron-3.5-lightning-free"; }
    { model = "opencode/nemotron-3-ultra-free"; }
    { model = "opencode/mimo-v2.5-free"; }
    { model = "opencode/ling-3.0-flash-fin-free"; }
  ];

  omoAgentNames = [
    "sisyphus"
    "hephaestus"
    "oracle"
    "librarian"
    "explore"
    "multimodal-looker"
    "prometheus"
    "metis"
    "momus"
    "atlas"
    "sisyphus-junior"
    "code-reviewer"
  ];

  omoCategoryNames = [
    "visual-engineering"
    "ultrabrain"
    "deep"
    "artistry"
    "quick"
    "unspecified-low"
    "unspecified-high"
    "writing"
  ];

  omoPinSpec = pkgs.writeText "omo-pin-spec.json" (
    builtins.toJSON {
      models = zenFreeModels;
      agents = omoAgentNames;
      categories = omoCategoryNames;
    }
  );
in
{
  home.packages = with pkgs; [
    sops
    age
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/secrets.yaml;
    secrets."github/mcp_token" = { };
    templates."opencode.jsonc" = {
      path = "${config.xdg.configHome}/opencode/opencode.jsonc";
      content = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        plugin = [ "oh-my-openagent@latest" ];
        mcp = {
          playwright = {
            type = "local";
            command = [
              "npx"
              "-y"
              "@playwright/mcp@latest"
              "--browser=chromium"
            ];
            enabled = true;
          };
          github = {
            type = "remote";
            url = "https://api.githubcopilot.com/mcp";
            enabled = true;
            oauth = false;
            headers = {
              Authorization = "Bearer ${config.sops.placeholder."github/mcp_token"}";
              X-MCP-Toolsets = "repos,issues";
              X-MCP-Readonly = "true";
            };
          };
          basic-memory = {
            type = "local";
            command = [
              "${config.home.homeDirectory}/.local/bin/basic-memory"
              "mcp"
            ];
            enabled = true;
          };
          postgres = {
            type = "local";
            command = [
              "npx"
              "-y"
              "@henkey/postgres-mcp-server@latest"
            ];
            environment.DATABASE_URL = "postgresql://REPLACE_WITH_READONLY_DSN";
            enabled = true;
          };
        };
      };
    };
  };

  home.activation = {
    pinOmoModel = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.python3}/bin/python3 - <<'EOF'
      import json, os
      spec = json.load(open("${omoPinSpec}"))
      path = os.path.expanduser("~/.omo/omo.jsonc")
      try:
          with open(path) as f:
              cfg = json.load(f)
      except (FileNotFoundError, json.JSONDecodeError):
          cfg = {}
      op = cfg.setdefault("[opencode]", {})
      changed = False
      for section in ("agents", "categories"):
          group = op.setdefault(section, {})
          for name in spec[section]:
              entry = group.setdefault(name, {})
              entry.pop("model", None)
              entry.pop("fallback_models", None)
              if entry.get("models") != spec["models"]:
                  entry["models"] = [m for m in spec["models"]]
                  changed = True
      if changed:
          with open(path, "w") as f:
              json.dump(cfg, f, indent=2)
          print("pinned omo agents/categories to Zen free models")
      EOF
    '';

    installBasicMemory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PATH="${config.home.homeDirectory}/.local/bin:$PATH"
      if [ ! -x "${config.home.homeDirectory}/.local/bin/basic-memory" ]; then
        $DRY_RUN_CMD ${pkgs.uv}/bin/uv tool install basic-memory \
          || echo "warning: basic-memory install failed (offline?) - rerun activation later"
      fi
    '';
  };
}
