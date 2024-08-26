[private]
default:
    just --list

# Levanta un servidor con el libro generado.
dev: install build-repl
    pnpm exec honkit serve

# Genera el libro.
build: install build-repl
    pnpm exec honkit build
    cp favicon.ico _book/gitbook/images/favicon.ico

# Da formato estándar a los archivos.
format:
    prettier '**/*.{md,json}' --write

# Verifica que todo funcione y que los archivos estén formateados.
check:
    pnpm exec honkit build
    prettier '**/*.{md,json}' --check

# Publica en Github Pages.
deploy: build
    pnpm exec gh-pages --dist ./_book

[private]
install:
    pnpm install

[private]
build-repl:
    cd repl && bash build.sh
