#!/bin/bash

echo "Got arg \"$1\""

if ! command -v uconv; then
    echo "Please install the uconv command"
    exit 1
else
    echo "Available transliterators are:"
    uconv -L
fi

IFS=$'\n'
for file in `git diff-tree --no-commit-id --name-only -r HEAD`; do
    if [ -f $file ]; then
        echo "Found \"$file\""
    else
        echo "Looked for but couldn't find \"$file\". Perhaps it was removed by that commit?"
    fi
done

