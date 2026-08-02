#!/usr/bin/env bash
set -euo pipefail

MANGO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=../../lib/mango-cli.sh
source "$MANGO_ROOT/lib/mango-cli.sh"

usage() {
  mango_usage "$0 <file> [-a md5|sha1|sha256]" \
    "-a, --algorithm   Hash algorithm (default: sha256)" \
    "-h, --help        Show help"
}

ALGO="sha256"
while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--algorithm) ALGO="$2"; shift 2 ;;
    -h|--help) usage ;;
    -*) mango_die "Unknown option: $1" ;;
    *) MANGO_INPUT="$1"; shift ;;
  esac
done

[[ -n "$MANGO_INPUT" ]] || usage
mango_require_input "$MANGO_INPUT"

case "$ALGO" in
  md5|sha1|sha256) ;;
  *) mango_die "Unsupported algorithm: $ALGO (use md5, sha1, sha256)" ;;
esac

if command -v shasum &>/dev/null; then
  case "$ALGO" in
    md5)    md5 -q "$MANGO_INPUT" ;;
    sha1)   shasum -a 1 "$MANGO_INPUT" | awk '{print $1}' ;;
    sha256) shasum -a 256 "$MANGO_INPUT" | awk '{print $1}' ;;
  esac
elif command -v openssl &>/dev/null; then
  openssl dgst -"$ALGO" "$MANGO_INPUT" | awk '{print $NF}'
else
  mango_die "Need shasum or openssl for hashing"
fi
