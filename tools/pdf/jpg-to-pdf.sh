#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <image> [image2...] -o output.pdf" \
    "-o, --output   Output PDF (required)" \
    "-h, --help     Show help"
}

PDFS=()
mango_parse_args usage "$@"

for arg in "$@"; do
  [[ "$arg" == -o || "$arg" == --output ]] && continue
  [[ "$arg" == "$MANGO_OUTPUT" ]] && continue
  [[ "$arg" =~ ^- ]] && continue
  PDFS+=("$arg")
done

[[ ${#PDFS[@]} -ge 1 ]] || usage
[[ -n "$MANGO_OUTPUT" ]] || mango_die "Output required (-o)"
require_python_pkg pypdf pypdf || exit 1
require_python_pkg Pillow Pillow || exit 1

for p in "${PDFS[@]}"; do mango_require_input "$p"; done
mango_run_python "$MANGO_ROOT/tools/pdf/jpg_to_pdf.py" "${PDFS[@]}" \
  -o "$(mango_abs_path "$MANGO_OUTPUT")"
