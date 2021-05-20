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
```

Unicode NFD 
â
Unicode NFKD    
â
 Encoded
Unicode NFC 
â
Unicode NFKC    
â

