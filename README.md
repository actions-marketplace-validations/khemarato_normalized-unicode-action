# Normalized Unicode

A GitHub Docker Action that checks recently committed source files for Unicode Normalization and optionally fixes any errors.

This action requires the `checkout` action be run before it with a depth of 2, and uses the [`uconv`](https://linux.die.net/man/1/uconv) command under the hood.

## Inputs

### `transliteration`

The name of the Unicode transliteration scheme you'd like to consider "normal".

**Default**: `Any-NFC`

### `commit_fix`

Whether it should automatically commit a fix for the offending file(s).

**Default**: false

### `token`

If you're using `actions/checkout` AND haven't manually set its `persist-credentials` to `false` AND would like commits from this action to **not** trigger another workflow run, then there's no need to set this parameter.

If you would like `actions/checkout` to *not* persist its credentials, OR if you would like this action's push to trigger a workflow, please set this parameter to a secret token.

**Default**: pulls the Action Token from the checkout action

### `exit_code`
 
The exit status if a file is found in need of normalization

**Default**: 1

## Outputs

### Exit status

Exits with code `exit_code` if there's an error, `0` otherwise.

## Example usage

```
- uses: actions/checkout@v2
  with:
    fetch-depth: 2 # required, to only check files touched by the last commit
- uses: buddhist-uni/normalized-unicode-action
  with:
    transliteration: Any-NFC
    exit_code: 1
    token: ${{ secrets.MY_GITHUB_TOKEN_SECRET }}
```

Unicode NFD 
â
Unicode NFKD    
â
 Encoded
Unicode NFC 
â
Unicode NFKC    
â

