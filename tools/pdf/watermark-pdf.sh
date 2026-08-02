#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input.pdf> -o output.pdf [-t text]" \
    "-o, --output   Output PDF (required)" \
    "-t, --text     Watermark text (default: CONFIDENTIAL)" \
    "-h, --help     Show help"
}

TEXT="CONFIDENTIAL"
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output) MANGO_OUTPUT="$2"; shift 2 ;;
    -t|--text) TEXT="$2"; shift 2 ;;
    -h|--help) usage ;;
    -*) mango_die "Unknown option: $1" ;;
    *) MANGO_INPUT="$1"; shift ;;
  esac
done

[[ -n "$MANGO_INPUT" ]] || usage
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output required (-o)"
mango_require_input "$MANGO_INPUT"
require_python_pkg pymupdf fitz || exit 1

mango_run_python "$MANGO_ROOT/tools/pdf/watermark_pdf.py" \
  "$MANGO_INPUT" \
  -o "$(mango_abs_path "$MANGO_OUTPUT")" \
  -t "$TEXT"
