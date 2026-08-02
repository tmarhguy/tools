#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <a.pdf> <b.pdf> ... -o merged.pdf" \
    "-o, --output   Output PDF (required)" \
    "-h, --help     Show help"
}

mango_parse_args usage "$@"

# Collect positional PDFs from original args
PDFS=()
for arg in "$@"; do
  [[ "$arg" == -o || "$arg" == --output ]] && continue
  [[ "$arg" == "$MANGO_OUTPUT" ]] && continue
  [[ "$arg" =~ ^- ]] && continue
  PDFS+=("$arg")
done

[[ ${#PDFS[@]} -ge 1 ]] || mango_die "Provide at least one PDF"
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output required (-o merged.pdf)"
require_python_pkg pypdf pypdf || exit 1

for p in "${PDFS[@]}"; do mango_require_input "$p"; done

args=("$MANGO_ROOT/tools/pdf/merge_pdf.py" "${PDFS[@]}" -o "$(mango_abs_path "$MANGO_OUTPUT")")
mango_run_python "${args[@]}"
