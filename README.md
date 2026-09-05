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

Nix-managed tools (e.g. `bun` in `modules/home/packages`) update by bumping
the `nixpkgs` lock entry, never via the tool's own updater (`bun upgrade`
cannot work — the Nix store is read-only):

```console
nix flake update nixpkgs
nix run .#activate
exec zsh -l
bun --version
```

#### Removing a Homebrew cask

Delete the entry from the `casks` list in `modules/darwin/default.nix`.
nix-darwin will not reinstall it, but apps brew does not track must be
deleted once by hand:

```console
sudo rm -rf /Applications/ZCode.app
nix run .#activate
```

### Secrets (sops-nix)

The GitHub MCP token in `modules/home/opencode` is injected from
`secrets/secrets.yaml`, which stays encrypted in git. First-time setup:

```console
age-keygen -o ~/.config/sops/age/keys.txt
```

Put the printed `age1...` public key into `.sops.yaml`, then store the secret:

```console
sops secrets/secrets.yaml
```

Replace `REPLACE_WITH_REAL_TOKEN` with a fresh fine-grained GitHub PAT,
save, and apply:

```console
nix run .#activate
```

To add another secret later, add it under a new key in
`secrets/secrets.yaml` via `sops secrets/secrets.yaml`, reference it in
`modules/home/opencode/default.nix` as
`config.sops.placeholder."<section>/<key>"`, and re-run activation.
Rotate any token that ever sat in plaintext config on the provider side.
