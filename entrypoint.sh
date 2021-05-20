#!/bin/bash

echo "Got arg \"$1\""

if ! command -v uconv; then
    echo "Please install the uconv command"
    exit 1
else
    echo "Available transliterators are:"
    uconv -L
fi

cd $GITHUB_WORKSPACE

IFS=$'\n'
foundsomething=false
TOUCHED_FILES=`git diff-tree --no-commit-id --name-only -r HEAD`
echo "Found touched files: \"$TOUCHED_FILES\""
if [ -z "$TOUCHED_FILES" ]; then
    echo "Didn't find any files modified by the last commit"
    echo "Perhaps you forgot to set checkout:fetch-depth to 2?"
    exit 1
fi

for file in `isutf8 -i $TOUCHED_FILES`; do
    foundsomething=true
    if [ -f $file ]; then
        echo "Found UTF8 file \"$file\""
    else
        echo "Looked for but couldn't find \"$file\". Perhaps it was removed by that commit?"
    fi
done

