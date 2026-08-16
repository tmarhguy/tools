#!/usr/bin/env bash
# Wrapper — Extract Audio (implementation lives in bin/extract-audio)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
exec "$ROOT/bin/extract-audio" "$@"
