#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input.pdf> -o output.pdf [-p password]" \
    "-o, --output    Output PDF (required)" \
    "-p, --password  Open password (prompted if omitted)" \
    "-h, --help      Show help"
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output required (-o)"
mango_require_input "$MANGO_INPUT"
require_python_pkg pypdf pypdf || exit 1

args=("$MANGO_ROOT/tools/pdf/protect_pdf.py" "$MANGO_INPUT" -o "$(mango_abs_path "$MANGO_OUTPUT")")
[[ -n "$MANGO_PASSWORD" ]] && args+=(-p "$MANGO_PASSWORD")

mango_run_python "${args[@]}"
