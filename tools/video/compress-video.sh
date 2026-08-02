#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <video> [-o output.mp4] [-q crf] [--preset NAME]" \
    "-o, --output   Output path (default: input_compressed.mp4)" \
    "-q, --quality  CRF 18–32, lower = better quality (default: 28)" \
    "--preset       x264 preset: ultrafast|fast|medium|slow (default: medium)" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
mango_require_input "$MANGO_INPUT"
require_cmd ffmpeg ffmpeg || exit 1

CRF="${MANGO_QUALITY:-28}"
PRESET="${MANGO_PRESET:-medium}"
case "$PRESET" in
  ultrafast|fast|medium|slow) ;;
  *) mango_die "Invalid preset: $PRESET (use ultrafast, fast, medium, or slow)" ;;
esac

if [[ -n "$MANGO_OUTPUT" ]]; then
  OUTPUT="$(mango_abs_path "$MANGO_OUTPUT")"
else
  OUTPUT="$(mango_abs_path "$(mango_default_output "$MANGO_INPUT" mp4")")"
  OUTPUT="${OUTPUT%.*}_compressed.mp4"
fi

before=$(stat -f%z "$MANGO_INPUT" 2>/dev/null || stat -c%s "$MANGO_INPUT")
echo "Compressing $(basename "$MANGO_INPUT") → $(basename "$OUTPUT") (CRF ${CRF}, preset ${PRESET})…"

ffmpeg -hide_banner -loglevel error -y \
  -i "$MANGO_INPUT" \
  -c:v libx264 -crf "$CRF" -preset "$PRESET" \
  -c:a aac -b:a 128k \
  -movflags +faststart \
  "$OUTPUT"

after=$(stat -f%z "$OUTPUT" 2>/dev/null || stat -c%s "$OUTPUT")
pct=$(( (before - after) * 100 / before ))
echo "Wrote $OUTPUT (${before} → ${after} bytes, ~${pct}% smaller)"
