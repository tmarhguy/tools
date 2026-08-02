#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input.json> [-o output.json] [--minify]" \
    "-o, --output   Output file (default: stdout)" \
    "-m, --minify   Minify instead of pretty-print" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"
[[ -z "$MANGO_INPUT" ]] && usage

mango_require_input "${MANGO_INPUT:-}"
require_python || exit 1

args=("$MANGO_ROOT/tools/dev/format_json.py" "$MANGO_INPUT")
[[ -n "$MANGO_OUTPUT" ]] && args+=("-o" "$MANGO_OUTPUT")
[[ "$MANGO_MINIFY" -eq 1 ]] && args+=("--minify")

mango_run_python "${args[@]}"
