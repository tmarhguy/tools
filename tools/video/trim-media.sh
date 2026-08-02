#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <media> -o output [--start SS] [--end SS]" \
    "-o, --output   Output file (required)" \
    "--start        Start time (e.g. 00:00:05 or 5)" \
    "--end          End time" \
    "-h, --help     Show help"
}

START=""
END=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output) MANGO_OUTPUT="$2"; shift 2 ;;
    --start) START="$2"; shift 2 ;;
    --end) END="$2"; shift 2 ;;
    -h|--help) usage ;;
    -*) mango_die "Unknown option: $1" ;;
    *) MANGO_INPUT="$1"; shift ;;
  esac
done

[[ -n "$MANGO_INPUT" ]] || usage
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output required (-o)"
mango_require_input "$MANGO_INPUT"
require_cmd ffmpeg ffmpeg || exit 1

OUTPUT="$(mango_abs_path "$MANGO_OUTPUT")"
args=(-hide_banner -loglevel error -y)
[[ -n "$START" ]] && args+=(-ss "$START")
args+=(-i "$MANGO_INPUT")
[[ -n "$END" ]] && args+=(-to "$END")
args+=(-c copy "$OUTPUT")

echo "Trimming → $(basename "$OUTPUT")…"
ffmpeg "${args[@]}"
echo "Wrote $OUTPUT"
