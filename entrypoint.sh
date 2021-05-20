#!/bin/bash

echo "Using transliterator \"$1\""

if ! command -v uconv; then
    echo "Please install the uconv command"
    exit 1
fi
TRANSLITS=`uconv -L`
if [[ ${TRANSLITS} != *" $1 "* ]]; then
    echo "But \"$1\" is not a valid transliterator."
    echo "Available transliterators are: $TRANSLITS"
    exit 1
fi

cd $GITHUB_WORKSPACE

TOUCHED_FILES=`git diff-tree --no-commit-id --name-only -r HEAD`
if [ -z "$TOUCHED_FILES" ]; then
    echo "Didn't find any files modified by the last commit"
    echo "Perhaps you forgot to set checkout:fetch-depth to 2?"
    exit 1
fi

modified=false
IFS=$'\n'
for file in `isutf8 -i $TOUCHED_FILES`; do
    if [ -f $file ]; then
        echo "Analyzing \"$file\"..."
        uconv -x "$1" "$file" > $HOME/tmp
        if cmp -s $HOME/tmp "$file"; then
            rm $HOME/tmp
            echo "...done"
        else
            echo "...modifying \"$file\""
            mv -f $HOME/tmp "$file"
            modified=true
        fi
    else
        echo "Looked for but couldn't find \"$file\". Perhaps it was removed by that commit?"
    fi
done

if $modified; then
    git status
    git commit -am "Fix naughty unicode files"
    git push --dry-run
    exit 1
else
    echo "Everything looks good!"
    exit 0
fi

