#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input.pdf> [-o output.pdf]" \
    "-o, --output   Output PDF (default: input_compressed.pdf)" \
    "-h, --help     Show help" \
    "" \
    "Uses Ghostscript when available; falls back to pymupdf otherwise."
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
mango_require_input "$MANGO_INPUT"

if [[ -n "$MANGO_OUTPUT" ]]; then
  OUTPUT="$(mango_abs_path "$MANGO_OUTPUT")"
else
  default="$(mango_default_output "$MANGO_INPUT" pdf)"
  OUTPUT="$(mango_abs_path "${default%.*}_compressed.pdf")"
fi

echo "Compressing $(basename "$MANGO_INPUT")…"

if command -v gs &>/dev/null; then
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
    -dNOPAUSE -dQUIET -dBATCH \
    -sOutputFile="$OUTPUT" "$MANGO_INPUT"
else
  require_python_pkg pymupdf fitz || exit 1
  mango_run_python "$MANGO_ROOT/tools/pdf/compress_pdf.py" "$MANGO_INPUT" -o "$OUTPUT"
fi

echo "Wrote $OUTPUT"
