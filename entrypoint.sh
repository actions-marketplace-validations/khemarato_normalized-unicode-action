#!/bin/bash

COMMIT_PREFIX="[normalized-unicode-action] Auto-Normalize to"

echo "Prefered exit code is: $2"

echo "Using Unicode converter at:"
if ! command -v uconv; then
    echo "Please install the uconv command"
    exit 1
fi

echo "Using transliterator: \"$1\""
TRANSLITS=`uconv -L`
if [[ ${TRANSLITS} != *" $1 "* ]]; then
    echo "...except \"$1\" does not exist."
    echo "Available transliterators are: $TRANSLITS"
    exit 1
fi

cd $GITHUB_WORKSPACE

LAST_COMMIT_MSG=`git log --format=%B -n 1 HEAD`
if [[ ${LAST_COMMIT_MSG} == *"$COMMIT_PREFIX"* ]]; then
    echo "Last commit is one of mine! Nvm :)"
    exit 0
fi

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
            echo "...okay"
        else
            echo "...IN NEED OF NORMALIZATION"
            mv -f $HOME/tmp "$file"
            modified=true
        fi
    else
        echo "Looked for but couldn't find \"$file\". Perhaps it was removed by that commit?"
    fi
done

if $modified; then
    echo "Found files in need of modification!"
    if $3; then
        echo "Committing changes:"
        REMOTE_REPO="https://${GITHUB_ACTOR}:${ACTIONS_RUNTIME_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
        git config user.name "${GITHUB_ACTOR}"
        git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
        git add .
        git commit -m "$COMMIT_PREFIX $1"
        git push $REMOTE_REPO
        echo "Successfully pushed? $?"
    fi
    exit $2
else
    echo "Everything looks good!"
    exit 0
fi

