#!/usr/bin/env bash
# Wrapper — Compress Video (implementation lives in bin/compress-video)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
exec "$ROOT/bin/compress-video" "$@"
