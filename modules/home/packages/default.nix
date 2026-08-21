{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Version control
    gh
    git
    git-filter-repo
    git-lfs

    # Shell tools
    atuin
    gum
    zinit
    zoxide

    # Files and text
    bat
    eza
    fd
    fzf
    ripgrep
    tree

    # Terminal applications
    jnv
    lazydocker
    serpl

    # Editor
    neovim

    # Development utilities
    dotenv-cli
    pipreqs
    tree-sitter

    # Language and development tooling
    air
    bun
    cargo
    fnm
    go
    golangci-lint
    gopls
    nodejs
    pnpm
    rustc
    typst
    uv
    yarn

    # Containers and migrations
    colima
    docker
    docker-buildx
    docker-compose
    docker-credential-helpers
    go-migrate

    # macOS utilities
    mactop
    mole-cleaner

    # Python tooling
    pyenv
    ruff
  ];
}
