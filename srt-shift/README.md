# srt-shift

Shift the timestamps of an `.srt` subtitle file forward or backward, either for the
whole file or only from a given instant onward. Python 3, no dependencies.

```
srt-shift.py [-h] [-f DELTA] [-b DELTA] [-o OFFSET] file_srt
```

| Option | Meaning |
|---|---|
| `-f DELTA`, `--forward DELTA` | delay subtitles by `DELTA` milliseconds |
| `-b DELTA`, `--backward DELTA` | anticipate subtitles by `DELTA` milliseconds |
| `-o OFFSET`, `--offset OFFSET` | only shift cues starting at or after `OFFSET`, given as `[[H:]M:]S` |

Exactly one of `-f` / `-b` is required.

## Examples

Subtitles appear 2 seconds too early, for the whole movie:

```
python3 srt-shift.py -f 2000 movie.srt
```

Subtitles drift out of sync after the 1:10:37 mark (e.g. a cut ad break); delay
everything from that point by 14.5 seconds and leave the first part untouched:

```
python3 srt-shift.py -f 14500 -o 1:10:37 movie.srt
```

## Behaviour

- The file is edited **in place**. The original is first copied to `<file>.backup`;
  if a backup already exists you are asked before it is overwritten.
- Only `start --> end` timing lines are touched; cue numbers, text and blank lines
  are written back unchanged.
- Timestamps that would become negative are clamped to `00:00:00,000`.
- Line endings (LF or CRLF) and any non-UTF-8 bytes are preserved as they are.
