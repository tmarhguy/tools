#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <image> [-o output] [-q quality]" \
    "-o, --output   Output path (default: overwrite input)" \
    "-q, --quality  JPEG/WebP quality 1-100 (default: 85)" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
mango_require_input "$MANGO_INPUT"
require_python_pkg Pillow Pillow || exit 1

args=("$MANGO_ROOT/tools/image/compress_image.py" "$MANGO_INPUT")
[[ -n "$MANGO_OUTPUT" ]] && args+=("-o" "$MANGO_OUTPUT")
[[ -n "$MANGO_QUALITY" ]] && args+=("-q" "$MANGO_QUALITY")

mango_run_python "${args[@]}"
