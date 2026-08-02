#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input> [-o output] [--decode]" \
    "Encode file to base64 (default) or decode with --decode" \
    "-o, --output   Output file (default: stdout)" \
    "-d, --decode   Decode base64 input" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"
[[ -z "$MANGO_INPUT" ]] && usage
mango_require_input "$MANGO_INPUT"

if [[ "$MANGO_DECODE" -eq 1 ]]; then
  if [[ -n "$MANGO_OUTPUT" ]]; then
    base64 -d -i "$MANGO_INPUT" -o "$MANGO_OUTPUT"
    echo "Wrote $MANGO_OUTPUT"
  else
    base64 -d -i "$MANGO_INPUT"
  fi
else
  if [[ -n "$MANGO_OUTPUT" ]]; then
    base64 -i "$MANGO_INPUT" -o "$MANGO_OUTPUT"
    echo "Wrote $MANGO_OUTPUT"
  else
    base64 -i "$MANGO_INPUT"
  fi
fi
