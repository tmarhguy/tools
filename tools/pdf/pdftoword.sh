#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input.pdf> -o output.docx" \
    "-o, --output   Output DOCX path (required)" \
    "-h, --help     Show help" \
    "" \
    "Note: works best on text-based PDFs. Scanned PDFs need OCR."
}

mango_parse_args usage "$@"

[[ -z "$MANGO_INPUT" ]] && usage
mango_require_input "$MANGO_INPUT"
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output path required (-o output.docx)"
require_python_pkg pdf2docx pdf2docx || exit 1

mango_run_python "$MANGO_ROOT/tools/pdf/pdftoword.py" "$MANGO_INPUT" -o "$(mango_abs_path "$MANGO_OUTPUT")"
