[private]
default:
    just --list

# Levanta un servidor con una previsualización del libro.
preview: install build-repl
    pnpm exec honkit serve

# Genera el libro.
build: install build-repl
    pnpm exec honkit build
    cp favicon.ico _book/gitbook/images/favicon.ico

# Da formato estándar a los archivos.
format:
    prettier '**/*.{md,json,yml}' --write
    alejandra *.nix

# Verifica que todo funcione y que los archivos estén formateados.
check: build
    prettier '**/*.{md,json,yml}' --check
    alejandra *.nix --check

# Publica en Github Pages.
deploy: build
    pnpm exec gh-pages --dist ./_book

# (CI) Publica en Github Pages.
deploy-ci: build
    pnpm exec gh-pages \
        --dist ./_book \
        --user 'github-actions-bot <support+actions@github.com>'

[private]
install:
    pnpm install

[private]
build-repl:
    cd repl && bash build.sh
