#!/bin/bash

set -e


## BUILD BOOK

pnpm install
pnpm exec gitbook install
pnpm link gitbook-plugin-elm-repl
sed -i 's/"youtube"/"youtube","elm-repl"/' book.json
pnpm exec gitbook build


## OVERRIDE FAVICON

cp favicon.ico _book/gitbook/images/favicon.ico
