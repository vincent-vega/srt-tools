#!/usr/bin/env bash
# srt <-> docx for Google Translate's "Documents" tab.
#   srt-convert.sh to-docx   in.srt          out.docx
#   srt-convert.sh from-docx translated.docx out.srt
#   eval "$(/path/to/srt-convert.sh --bash)"   # in ~/.bashrc, for completion
set -euo pipefail

case "${1:-}" in
  to-docx)
    # <i>..</i> -> *..* so pandoc keeps italics (raw html is dropped in docx).
    # ponytail: whole cue = one paragraph, so Google translates with full context;
    # wrapped lines get joined. Dialog lines ("- ...") get a hard break (trailing \)
    # so they stay split. Use +hard_line_breaks to keep every line split instead.
    sed 's#</\{0,1\}i>#*#g' "$2" | perl -00 -pe 's/^((?!.*-->).+)\n(?=\*?-)/$1\\\n/mg' |
      pandoc -f markdown-smart -t docx -o "$3" ;;
  from-docx)
    # one paragraph per cue: "N  start  <any arrow>  end  text"
    pandoc "$2" -t commonmark --wrap=none | perl -00 -pe '
      s/^(\d+)\s+(\S+)\s+\S+\s+(\S+)\s*/$1\n$2 --> $3\n/;
      s/\\\n/\n/g;
      s/\*([^*]+)\*/<i>$1<\/i>/g;
      s/\\(.)/$1/g;
      s/\s*$/\n\n/;' > "$3" ;;
  --bash)
    sed -n "/^_srt_convert() {/,/^complete /p" "$0" ;;
  *) sed -n '2,4p' "$0"; exit 1 ;;
esac

# bash completion, printed by --bash
_srt_convert() {
  local cur=${COMP_WORDS[COMP_CWORD]} ext IFS
  case $COMP_CWORD in
    1) COMPREPLY=($(compgen -W 'to-docx from-docx' -- "$cur")) ;;
    2) [[ ${COMP_WORDS[1]} == from-docx ]] && ext=docx || ext=srt
       IFS=$'\n'
       COMPREPLY=($(compgen -d -- "$cur"; compgen -f -X "!*.$ext" -- "$cur")) ;;
  esac
}
complete -o default -o filenames -F _srt_convert srt-convert
