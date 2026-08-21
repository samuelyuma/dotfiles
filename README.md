# dotfiles

Declarative configuration for my system settings.

## Folder structure

```text
.
├── .envrc
├── .gitignore
├── README.md
├── configurations
│   └── darwin
│       └── default.nix
├── flake.lock
├── flake.nix
└── modules
    ├── darwin
    │   └── default.nix
    └── home
        ├── default.nix
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

#### Format and check the flake

```console
nix fmt
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

Reload the shell after activation:

```console
exec zsh -l
```
