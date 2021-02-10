#!/bin/bash

# Quit on errors
set -o errexit

# Quit on unbound symbols
set -o nounset

check_script () {
    shellcheck run-tests.sh
}

check_docstyle () {
    npx -p markdownlint-cli markdownlint docs/*
    awesome_bot --allow-dupe --skip-save-results --allow-redirect docs/**/*.md
}

build_docs () {
    mkdocs build -v
    rm -rf site/
}

if [ $# -eq 0 ]; then
    check_script
    check_docstyle
    build_docs
fi

for arg in "$@"
do
    case $arg in
        --check-shellscript) check_script;;
        --check-docstyle) check_docstyle;;
        --build-docs) build_docs;;
        *)
    esac
done
