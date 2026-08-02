#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <input.pdf> -o <output-dir>" \
    "-o, --output   Output directory (required)" \
    "--pages        Optional range e.g. 1-3" \
    "-h, --help     Show help"
}

PAGES=""
OUT_DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output) OUT_DIR="$2"; shift 2 ;;
    --pages) PAGES="$2"; shift 2 ;;
    -h|--help) usage ;;
    -*) mango_die "Unknown option: $1" ;;
    *) MANGO_INPUT="$1"; shift ;;
  esac
done

[[ -n "$MANGO_INPUT" ]] || usage
[[ -n "$OUT_DIR" ]] || usage
mango_require_input "$MANGO_INPUT"
require_python_pkg pypdf pypdf || exit 1

args=("$MANGO_ROOT/tools/pdf/split_pdf.py" "$MANGO_INPUT" -o "$(mango_abs_path "$OUT_DIR")")
[[ -n "$PAGES" ]] && args+=(--pages "$PAGES")
mango_run_python "${args[@]}"
