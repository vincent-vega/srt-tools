# srt-convert

Convert `.srt` subtitles to `.docx` and back, so a whole file can be translated with
Google Translate's "Documents" tab while keeping cue numbers, timings and italics.

Requires `pandoc` and `perl`.

```
srt-convert.sh to-docx   in.srt          out.docx
srt-convert.sh from-docx translated.docx out.srt
```

Each cue becomes one paragraph, so Google translates it with full context.
`<i>...</i>` is mapped to `*...*` on the way out and restored on the way back.

Bash completion:

```
eval "$(/path/to/srt-convert.sh --bash)"   # in ~/.bashrc
```
