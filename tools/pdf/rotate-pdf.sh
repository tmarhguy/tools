#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input.pdf> -o output.pdf [-r 90|180|270]" \
    "-o, --output   Output PDF" \
    "-r, --rotate   Rotation degrees (default: 90)" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output required (-o)"
mango_require_input "$MANGO_INPUT"
require_python_pkg pypdf pypdf || exit 1

ROTATE="${MANGO_ROTATE:-90}"
mango_run_python "$MANGO_ROOT/tools/pdf/rotate_pdf.py" "$MANGO_INPUT" \
  -o "$(mango_abs_path "$MANGO_OUTPUT")" -r "$ROTATE"
