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

If you'd like the pushed fix here to trigger another workflow run, you'll have to set this to a personal access token.

If you don't want its pushes to trigger another workflow run, then use either the `${{ secrets.GITHUB_TOKEN }}` or just use `actions/checkout@v2` which, by default, persists that credential down to later steps like this one.

Obviously, this is unnecessary if `commit_fix` is `false`.

**Default**: Attempts to pull the Action Token from the checkout action

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
    token: ${{ secrets.GITHUB_TOKEN }}
```

 Decoded
Unicode NFD 
â
Unicode NFKD    
â
 Encoded
Unicode NFC 
â
Unicode NFKC    
â

