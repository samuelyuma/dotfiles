# dotfiles

Declarative configuration for my system settings.

## Requirements

- Nix with the `nix-command` and `flakes` features enabled
- direnv, if the development shell should load automatically through `.envrc`

## Commands

```bash
nix develop              # enter the development shell
nix fmt                  # format Nix files
nix flake check          # check the flake
nix flake update         # update flake inputs
```
