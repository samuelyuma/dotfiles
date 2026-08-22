{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Version control
    gh
    git-filter-repo
    git-lfs

    # Shell tools
    gum
    zinit

    # Files and text
    bat
    eza
    fd
    ripgrep
    tree

    # Terminal applications
    jnv
    lazydocker
    serpl

    # Development utilities
    dotenv-cli
    pipreqs
    tree-sitter

    # Language and development tooling
    air
    bun
    cargo
    go
    golangci-lint
    gopls
    nodejs
    pnpm
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
    ruff
  ];
}
