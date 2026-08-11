#!/usr/bin/env bash
# Unit tests for Mango folder browser (lib/mango-ui.sh)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=../lib/mango-ui.sh
source "$ROOT/lib/mango-ui.sh"

pass() { echo "  ok: $1"; }
fail() { echo "  FAIL: $1"; exit 1; }

echo "Mango browse tests"
echo "──────────────────"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir"/{photos,docs,shots,empty,nested}
touch "$tmpdir/photos/a.jpg" "$tmpdir/shots/b.png" "$tmpdir/nested/c.JPEG"
touch "$tmpdir/docs/readme.txt"

items=()
_mango_browse_list_items items "$tmpdir" "$tmpdir" jpg jpeg png webp gif
[[ ${#items[@]} -eq 3 ]] || fail "root should list 3 folders with images (got ${#items[@]})"
printf '%s\n' "${items[@]}" | grep -q '^dir|photos$' || fail "missing photos/"
printf '%s\n' "${items[@]}" | grep -q '^dir|shots$' || fail "missing shots/"
printf '%s\n' "${items[@]}" | grep -q '^dir|nested$' || fail "missing nested/"
printf '%s\n' "${items[@]}" | grep -q 'docs' && fail "docs/ should not appear"
pass "root lists only folders with matching images"

items=()
_mango_browse_list_items items "$tmpdir/photos" "$tmpdir" jpg jpeg png
[[ ${#items[@]} -eq 2 ]] || fail "photos dir should have parent + file (got ${#items[@]})"
printf '%s\n' "${items[@]}" | grep -q '^dir|\.\.$' || fail "missing parent"
printf '%s\n' "${items[@]}" | grep -q '^file|a\.jpg$' || fail "missing a.jpg"
pass "subdir lists parent and matching files"

items=()
_mango_browse_list_items items "$tmpdir/empty" "$tmpdir" jpg
[[ ${#items[@]} -eq 1 ]] || fail "empty dir should only show parent (got ${#items[@]})"
[[ "${items[0]}" == "dir|.." ]] || fail "expected parent only"
pass "empty subdir shows parent only"

_mango_dir_has_matching_files "$tmpdir/photos" jpg || fail "photos should have jpg"
! _mango_dir_has_matching_files "$tmpdir/empty" jpg || fail "empty should not match"
! _mango_dir_has_matching_files "$tmpdir/docs" jpg || fail "docs should not match"
pass "_mango_dir_has_matching_files"

short=$(_mango_short_path "$HOME")
[[ "$short" == "~" ]] || fail "short path for HOME should be ~ (got $short)"
pass "_mango_short_path"

echo ""
echo "All browse tests passed."
