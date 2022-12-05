#!/bin/bash

COMMIT_PREFIX="[normalized-unicode-action] Auto-Normalize to"

echo "Prefered exit code is: $2"

echo "Using Unicode converter at:"
if ! command -v uconv; then
    echo "Please install the uconv command"
    exit 1
fi

echo "Using Unicode finder at:"
if ! command -v isutf8; then
    echo "Please install the isutf8 command"
    exit 1
fi

echo "Using transliterator: \"$1\""
TRANSLITS=`uconv -L`
if [[ ${TRANSLITS} != *" $1 "* ]]; then
    echo "...except \"$1\" does not exist."
    echo "Available transliterators are: $TRANSLITS"
    exit 1
fi

TOKEN="$ACTIONS_RUNTIME_TOKEN"
if [[ ! -z "$INPUT_TOKEN" ]]; then
    TOKEN="$INPUT_TOKEN"
    echo "Got a manually supplied token."
else
    echo "Will use the default ACTIONS_RUNTIME_TOKEN."
fi

# Workaround for https://github.com/actions/checkout/issues/766
git config --global --add safe.directory "$GITHUB_WORKSPACE"

cd "$GITHUB_WORKSPACE"

LAST_COMMIT_MSG=`git log --format=%B -n 1 HEAD`
if [[ ${LAST_COMMIT_MSG} == "$COMMIT_PREFIX"* ]]; then
    echo "Last commit is one of mine! Nvm :)"
    exit 0
fi

if "$4"; then
  TOUCHED_FILES=`git ls-files`
else
  TOUCHED_FILES=`git diff-tree --no-commit-id --diff-filter=d --diff-merges=1 --name-only -r HEAD`
  if [ -z "$TOUCHED_FILES" ]; then
    echo "Didn't find any files modified by the last commit"
    echo "Perhaps you forgot to set checkout:fetch-depth to 2?"
    exit 0
  fi
fi

modified=false
IFS=$'\n'
for file in $TOUCHED_FILES; do
  if [[ -z `isutf8 "$file"` ]]; then
    if [ -f "$file" ]; then
        echo "Analyzing \"$file\"..."
        if uconv -x "$1" "$file" > $HOME/tmp; then
          if cmp -s $HOME/tmp "$file"; then
            rm $HOME/tmp
            echo "...okay"
          else
            echo "...IN NEED OF NORMALIZATION"
            mv -f $HOME/tmp "$file"
            modified=true
          fi
        else
          echo "There was a problem converting $file. Is it really unicode?"
        fi
    else
        echo "Looked for but couldn't find \"$file\"."
        exit 1
    fi
  fi
done

if $modified; then
    if "$3"; then
        echo "Committing changes:"
        REMOTE_REPO="https://${GITHUB_ACTOR}:${TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
        git config user.name "${GITHUB_ACTOR}"
        git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
        git add .
        git commit -m "$COMMIT_PREFIX $1"
        RESULT=$(git push $REMOTE_REPO 2>&1)
        if [[ "$RESULT" == *"fatal: "* ]]; then
            echo "Failed to push the fix!"
            echo "Use actions/checkout (@v2 with \"persist-credentials: true\") OR pass me a personal access \"token\"."
            exit 1
        fi
        echo "Successfully pushed!"
    fi
    exit $2
else
    echo "Everything looks good! No fix needed :)"
    exit 0
fi

