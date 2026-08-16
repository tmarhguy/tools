#!/usr/bin/env bash
# Wrapper — Video → GIF (implementation lives in bin/to_gif)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
exec "$ROOT/bin/to_gif" "$@"
