#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <video> [-o output.gif] [-w width]" \
    "-o, --output   Output GIF path (default: same name .gif)" \
    "-w, --width    Scale to width in pixels (default: 480)" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
mango_require_input "$MANGO_INPUT"
require_cmd ffmpeg ffmpeg || exit 1

WIDTH="${MANGO_WIDTH:-480}"
OUTPUT="${MANGO_OUTPUT:-$(mango_default_output "$MANGO_INPUT" gif)}"
OUTPUT="$(mango_abs_path "$OUTPUT")"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

palette="$tmpdir/palette.png"
filters="fps=15,scale=${WIDTH}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse"

echo "Converting $(basename "$MANGO_INPUT") → $(basename "$OUTPUT") (width ${WIDTH}px)…"

ffmpeg -hide_banner -loglevel error -y \
  -i "$MANGO_INPUT" \
  -vf "$filters" \
  -loop 0 \
  "$OUTPUT"

echo "Wrote $OUTPUT"
