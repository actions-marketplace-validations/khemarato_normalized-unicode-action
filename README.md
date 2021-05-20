# Normalized Unicode

A GitHub Docker Action that checks recently committed source files for Unicode Normalization and optionally fixes any errors.

This action requires the `checkout` action be run before it, and uses the [`uconv`](https://linux.die.net/man/1/uconv) command under the hood.

## Inputs

### `transliteration`

**Required** The name of the Unicode transliteration scheme you'd like to consider "normal".

**Default**: `Any-NFC`

## Outputs

### Exit status

Exits with code `1` if there's an error, `0` otherwise.

## Example usage

```
- uses: actions/checkout@v2
- uses: buddhist-uni/normalized-unicode-action
  with:
    transliteration: Any-NFC
```
