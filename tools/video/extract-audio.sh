#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <video> [-o output.mp3] [-f mp3|wav]" \
    "-o, --output   Output audio file" \
    "-f, --format   mp3 or wav (default: mp3)" \
    "-h, --help     Show help"
}

FORMAT="mp3"
mango_parse_args usage "$@"
[[ -n "$MANGO_FORMAT" ]] && FORMAT="$MANGO_FORMAT"

[[ -z "$MANGO_INPUT" ]] && usage
mango_require_input "$MANGO_INPUT"
require_cmd ffmpeg ffmpeg || exit 1

OUTPUT="${MANGO_OUTPUT:-$(mango_default_output "$MANGO_INPUT" "$FORMAT")}"
OUTPUT="$(mango_abs_path "$OUTPUT")"

case "$FORMAT" in
  mp3) codec="-vn -acodec libmp3lame -q:a 2" ;;
  wav) codec="-vn -acodec pcm_s16le" ;;
  *) mango_die "Format must be mp3 or wav" ;;
esac

echo "Extracting audio → $(basename "$OUTPUT")…"
# shellcheck disable=SC2086
ffmpeg -hide_banner -loglevel error -y -i "$MANGO_INPUT" $codec "$OUTPUT"
echo "Wrote $OUTPUT"
