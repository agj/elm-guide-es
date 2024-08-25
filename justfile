[private]
default:
    just --list

# Genera el libro.
build: install
    cd repl && bash build.sh
    pnpm exec honkit build
    cp favicon.ico _book/gitbook/images/favicon.ico

[private]
install:
    pnpm install
