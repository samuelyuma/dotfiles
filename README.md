# dotfiles

Declarative configuration for my system settings.

## Folder Structure

```text
.
├── .envrc
├── .gitignore
├── .sops.yaml
├── README.md
├── configurations
│   └── darwin
│       └── default.nix
├── flake.lock
├── flake.nix
├── secrets
│   └── secrets.yaml
└── modules
    ├── darwin
    │   └── default.nix
    └── home
        ├── default.nix
        ├── editor
        │   └── default.nix
        ├── opencode
        │   └── default.nix
        ├── packages
        │   └── default.nix
        ├── shell
        │   ├── default.nix
        │   └── starship.toml
        ├── terminal
        │   ├── default.nix
        │   └── ghostty.conf
        └── vcs
            └── git.nix
```

## Usage

### Prerequisite

- Nix with the `nix-command` and `flakes` features enabled
- `sudo` access for applying the system configuration
- `direnv` is optional

This flake uses the existing Nix installation. nix-darwin does not configure Nix itself because `nix.enable = false` is set for the Determinate Nix setup.

### Setup

Run these commands from the repository root.

#### Enter the development shell

```console
nix develop
```

To load the shell automatically through direnv:

```console
direnv allow
```

Entering the development shell installs the repository's Git hooks. Formatting
and lint checks run before each commit, while the full flake check runs before
each push.

#### Format and check the flake

```console
nix fmt -- --ci
statix check .
deadnix .
nix flake check
```

#### Build the Darwin configuration

Build the configuration without activating it:

```console
nix build .#darwinConfigurations.darwin.system
```

#### Apply the configuration

The flake provides an activation command that handles the required elevation internally:

```console
nix run .#activate
```

From another directory, reference the repository directly:

```console
nix run /path/to/dotfiles#activate
```

#### Rollback to the previous generation

Use nix-darwin's native rollback command if the latest activation causes a problem:

```console
sudo darwin-rebuild --rollback
```

Reload the shell after activation:

```console
exec zsh -l
```

#### Updating packages

Nix-managed tools (declared in `modules/home/packages`) update by bumping
the `nixpkgs` lock entry, never via the tool's own updater (e.g. `bun
upgrade` cannot work — the Nix store is read-only). Replace `<package>`
with any tool name to verify it:

```console
nix flake update nixpkgs
nix run .#activate
exec zsh -l
<package> --version
```

#### Removing a Homebrew cask

Delete the entry from the `casks` list in `modules/darwin/default.nix`,
then activate — with `onActivation.cleanup = "uninstall"`, brew removes
any tracked cask missing from the list. Apps brew does not track (e.g. a
leftover `<AppName>.app` installed by hand) must be deleted once manually:

```console
sudo rm -rf "/Applications/<AppName>.app"
nix run .#activate
```

### Secrets (sops-nix)

GitHub tokens in `modules/home/opencode` (MCP) and `modules/home/vcs`
(git push/pull) are injected from `secrets/secrets.yaml`, which stays
encrypted in git. First-time setup:

```console
age-keygen -o ~/.config/sops/age/keys.txt
```

Put the printed `age1...` public key into `.sops.yaml`, then store the secrets:

```console
sops secrets/secrets.yaml
```

#### Generating the tokens

Create two separate fine-grained PATs at **github.com → Settings →
Developer settings → Personal access tokens → Fine-grained tokens →
Generate new token**. Never reuse one token for both — they have different
scopes and travel to different endpoints:

- `mcp_token` (read-only API use), repository access limited to the repos
  you work in, permissions **Contents: Read**, **Issues: Read**,
  **Metadata: Read**
- `personal_access_token` (push/pull), same repository selection, permissions
  **Contents: Read and write**, **Metadata: Read**

Both expire (90 days recommended). When pushes or MCP calls start failing
with auth errors, regenerate at the same page and continue below. If a
selected repo sits in an org with SAML enforcement, click **Configure SSO
→ Authorize** on the token or org access silently fails.

Replace the placeholders, save, and apply:

```yaml
github:
  mcp_token: github_pat_11...
  personal_access_token: github_pat_11...
```

```console
nix run .#activate
```

Until `github/personal_access_token` exists in `secrets.yaml`, git keeps
using an in-memory cache (this git is built without osxkeychain support);
the sops-rendered `~/.git-credentials` takes over automatically on the
first activation after you add it.

To add another secret later, add it under a new key in
`secrets/secrets.yaml` via `sops secrets/secrets.yaml`, reference it in
nix as `config.sops.placeholder."<section>/<key>"`, and re-run activation.
Rotate any token that ever sat in plaintext config on the provider side.
