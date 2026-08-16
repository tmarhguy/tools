#!/usr/bin/env bash
# Wrapper — Trim Media (implementation lives in bin/trim-media)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
exec "$ROOT/bin/trim-media" "$@"
