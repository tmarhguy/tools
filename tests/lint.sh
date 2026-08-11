#!/usr/bin/env bash
# Static analysis — shellcheck (bash) + ruff (python)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FAIL=0
warn() { echo "  warn: $*"; }
fail() { echo "  FAIL: $*"; FAIL=1; }
pass() { echo "  ok: $1"; }

echo "Lint"
echo "────"

# ── Shellcheck ──────────────────────────────────────────────────────────────────

if command -v shellcheck &>/dev/null; then
  mapfile -t SH_FILES < <(
    find "$ROOT/bin" "$ROOT/lib" "$ROOT/tools" -type f \( -name '*.sh' -o ! -name '*.*' \) -perm +111 2>/dev/null \
      | while read -r f; do head -1 "$f" 2>/dev/null | grep -q 'bash' && echo "$f"; done
    printf '%s\n' "$ROOT/setup.sh" "$ROOT/mango" "$ROOT/tests/smoke.sh" "$ROOT/tests/run.sh" "$ROOT/tests/lint.sh" "$ROOT/tests/test_browse.sh"
  )
  # dedupe
  mapfile -t SH_FILES < <(printf '%s\n' "${SH_FILES[@]}" | LC_ALL=C sort -u)

  if shellcheck -x -S warning "${SH_FILES[@]}"; then
    pass "shellcheck (${#SH_FILES[@]} scripts)"
  else
    fail "shellcheck"
  fi
elif [[ "${CI:-}" == "true" ]]; then
  fail "shellcheck not installed (required in CI)"
else
  warn "shellcheck not installed — skip (brew install shellcheck / apt install shellcheck)"
fi

# ── Ruff (Python) ───────────────────────────────────────────────────────────────

PY="$ROOT/.venv/bin/python"
command -v "$PY" &>/dev/null || PY=python3

if "$PY" -m ruff --version &>/dev/null; then
  if "$PY" -m ruff check "$ROOT/tools"; then
    pass "ruff"
  else
    fail "ruff"
  fi
elif [[ "${CI:-}" == "true" ]]; then
  fail "ruff not installed (pip install -r requirements-dev.txt)"
else
  warn "ruff not installed — skip (pip install -r requirements-dev.txt)"
fi

echo ""
if [[ "$FAIL" -eq 0 ]]; then
  echo "Lint passed."
else
  echo "Lint failed."
  exit 1
fi
