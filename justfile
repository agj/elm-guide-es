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

[private]
install:
    pnpm install

[private]
build-repl:
    cd repl && bash build.sh
