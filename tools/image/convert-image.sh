#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <image> -o output [-f format]" \
    "-o, --output   Output path (required)" \
    "-f, --format   jpg, png, webp, gif" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output required (-o)"
mango_require_input "$MANGO_INPUT"
require_python_pkg Pillow Pillow || exit 1

args=("$MANGO_ROOT/tools/image/convert_image.py" "$MANGO_INPUT" \
  -o "$(mango_abs_path "$MANGO_OUTPUT")")
[[ -n "$MANGO_FORMAT" ]] && args+=(-f "$MANGO_FORMAT")
mango_run_python "${args[@]}"
