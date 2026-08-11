#!/usr/bin/env bash
# Smoke tests — verify every registered Mango tool works

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIX="$ROOT/tests/fixtures"
PY="$ROOT/.venv/bin/python"
command -v "$PY" &>/dev/null || PY=python3
# shellcheck source=../lib/mango-deps.sh
source "$ROOT/lib/mango-deps.sh"
FAIL=0

pass() { echo "  ok: $1"; }
fail() { echo "  FAIL: $1"; FAIL=1; }
skip() { echo "  skip: $1"; }

echo "Mango smoke tests (all tools)"
echo "─────────────────────────────"

mkdir -p "$FIX"
export FIX

# ── Fixtures ────────────────────────────────────────────────────────────────────

"$PY" - <<'PY'
import os
from pypdf import PdfWriter
from PIL import Image

fix = os.environ["FIX"]
os.makedirs(fix, exist_ok=True)

for name in ("a", "b"):
    w = PdfWriter()
    w.add_blank_page(200, 200)
    with open(os.path.join(fix, f"{name}.pdf"), "wb") as f:
        w.write(f)

img = Image.new("RGB", (64, 64), color=(255, 128, 0))
img.save(os.path.join(fix, "sample.png"))
img.save(os.path.join(fix, "sample.jpg"), quality=95)
PY

echo '{"hello":"world"}' > "$FIX/sample.json"
echo "name,value" > "$FIX/sample.csv"
echo "hello" > "$FIX/sample.txt"

# ── Every tool: --help ──────────────────────────────────────────────────────────

ALL_TOOLS=(
  to_gif extract-audio trim-media compress-video
  compress-image convert-image strip-exif
  pdftoword merge-pdf split-pdf rotate-pdf jpg-to-pdf pdf-to-jpg compress-pdf
  protect-pdf unlock-pdf watermark-pdf
  format-json hash-gen base64-tool csv-to-json
)

for tool in "${ALL_TOOLS[@]}"; do
  if "$ROOT/bin/$tool" --help &>/dev/null || "$ROOT/bin/$tool" -h &>/dev/null; then
    pass "$tool --help"
  else
    fail "$tool --help"
  fi
done

# ── Developer tools ─────────────────────────────────────────────────────────────

if "$ROOT/bin/format-json" "$FIX/sample.json" -o "$FIX/sample.pretty.json" 2>/dev/null \
  && [[ -f "$FIX/sample.pretty.json" ]]; then
  pass "format-json"
else
  fail "format-json"
fi

if "$ROOT/bin/format-json" "$FIX/sample.json" -o "$FIX/sample.min.json" -m 2>/dev/null \
  && [[ -f "$FIX/sample.min.json" ]]; then
  pass "format-json --minify"
else
  fail "format-json --minify"
fi

if "$ROOT/bin/csv-to-json" "$FIX/sample.csv" -o "$FIX/from.csv.json" 2>/dev/null \
  && [[ -f "$FIX/from.csv.json" ]]; then
  pass "csv-to-json"
else
  fail "csv-to-json"
fi

if "$ROOT/bin/hash-gen" "$FIX/sample.json" &>/dev/null; then
  pass "hash-gen"
else
  fail "hash-gen"
fi

if "$ROOT/bin/base64-tool" "$FIX/sample.json" -o "$FIX/encoded.b64" 2>/dev/null \
  && "$ROOT/bin/base64-tool" "$FIX/encoded.b64" -o "$FIX/decoded.json" --decode 2>/dev/null \
  && diff -q "$FIX/sample.json" "$FIX/decoded.json" &>/dev/null; then
  pass "base64-tool"
else
  fail "base64-tool"
fi

# ── Image tools ─────────────────────────────────────────────────────────────────

if "$ROOT/bin/compress-image" "$FIX/sample.png" -o "$FIX/compressed.png" 2>/dev/null \
  && [[ -f "$FIX/compressed.png" ]]; then
  pass "compress-image"
else
  fail "compress-image"
fi

if "$ROOT/bin/convert-image" "$FIX/sample.png" -o "$FIX/converted.webp" 2>/dev/null \
  && [[ -f "$FIX/converted.webp" ]]; then
  pass "convert-image"
else
  fail "convert-image"
fi

if "$ROOT/bin/strip-exif" "$FIX/sample.jpg" -o "$FIX/stripped.jpg" 2>/dev/null \
  && [[ -f "$FIX/stripped.jpg" ]]; then
  pass "strip-exif"
else
  fail "strip-exif"
fi

# ── PDF tools ───────────────────────────────────────────────────────────────────

if "$ROOT/bin/merge-pdf" "$FIX/a.pdf" "$FIX/b.pdf" -o "$FIX/merged.pdf" 2>/dev/null \
  && [[ -f "$FIX/merged.pdf" ]]; then
  pass "merge-pdf"
else
  fail "merge-pdf"
fi

rm -rf "$FIX/split_out" && mkdir -p "$FIX/split_out"
if "$ROOT/bin/split-pdf" "$FIX/a.pdf" -o "$FIX/split_out" 2>/dev/null \
  && ls "$FIX/split_out"/*.pdf &>/dev/null; then
  pass "split-pdf"
else
  fail "split-pdf"
fi

if "$ROOT/bin/rotate-pdf" "$FIX/a.pdf" -o "$FIX/rotated.pdf" 2>/dev/null \
  && [[ -f "$FIX/rotated.pdf" ]]; then
  pass "rotate-pdf"
else
  fail "rotate-pdf"
fi

if "$ROOT/bin/jpg-to-pdf" "$FIX/sample.jpg" -o "$FIX/from_img.pdf" 2>/dev/null \
  && [[ -f "$FIX/from_img.pdf" ]]; then
  pass "jpg-to-pdf"
else
  fail "jpg-to-pdf"
fi

rm -rf "$FIX/jpg_out" && mkdir -p "$FIX/jpg_out"
if "$ROOT/bin/pdf-to-jpg" "$FIX/a.pdf" -o "$FIX/jpg_out" 2>/dev/null \
  && ls "$FIX/jpg_out"/*.jpg &>/dev/null; then
  pass "pdf-to-jpg"
else
  fail "pdf-to-jpg"
fi

if command -v gs &>/dev/null; then
  if "$ROOT/bin/compress-pdf" "$FIX/a.pdf" -o "$FIX/compressed.pdf" 2>/dev/null \
    && [[ -f "$FIX/compressed.pdf" ]]; then
    pass "compress-pdf"
  else
    fail "compress-pdf"
  fi
else
  skip "compress-pdf (ghostscript not installed)"
fi

if "$ROOT/bin/protect-pdf" "$FIX/a.pdf" -o "$FIX/protected.pdf" -p "test123" 2>/dev/null \
  && [[ -f "$FIX/protected.pdf" ]]; then
  pass "protect-pdf"
else
  fail "protect-pdf"
fi

if "$ROOT/bin/unlock-pdf" "$FIX/protected.pdf" -o "$FIX/unlocked.pdf" -p "test123" 2>/dev/null \
  && [[ -f "$FIX/unlocked.pdf" ]]; then
  pass "unlock-pdf"
else
  fail "unlock-pdf"
fi

if "$ROOT/bin/watermark-pdf" "$FIX/a.pdf" -o "$FIX/watermarked.pdf" -t "TEST" 2>/dev/null \
  && [[ -f "$FIX/watermarked.pdf" ]]; then
  pass "watermark-pdf"
else
  fail "watermark-pdf"
fi

if "$ROOT/bin/pdftoword" "$FIX/a.pdf" -o "$FIX/out.docx" 2>/dev/null \
  && [[ -f "$FIX/out.docx" ]]; then
  pass "pdftoword"
else
  fail "pdftoword"
fi

# ── Video tools (require ffmpeg) ────────────────────────────────────────────────

FFMPEG=""
if command -v ffmpeg &>/dev/null; then
  FFMPEG=ffmpeg
elif FFMPEG=$(mango_ffmpeg 2>/dev/null); then
  :
fi

if [[ -n "$FFMPEG" ]]; then
  TEST_VIDEO="$FIX/sample.mp4"
  "$FFMPEG" -hide_banner -loglevel error -y \
    -f lavfi -i "smptebars=size=64x64:rate=10:duration=1" \
    -f lavfi -i "sine=frequency=440:duration=1:sample_rate=44100" \
    -c:v libx264 -pix_fmt yuv420p -c:a aac -shortest "$TEST_VIDEO" 2>/dev/null || true

  if [[ -f "$TEST_VIDEO" ]]; then
    if "$ROOT/bin/to_gif" "$TEST_VIDEO" -o "$FIX/sample.gif" && [[ -s "$FIX/sample.gif" ]]; then
      pass "to_gif"
    else
      fail "to_gif"
    fi

    if "$ROOT/bin/extract-audio" "$TEST_VIDEO" -o "$FIX/sample.mp3" && [[ -s "$FIX/sample.mp3" ]]; then
      pass "extract-audio"
    else
      fail "extract-audio"
    fi

    if "$ROOT/bin/trim-media" "$TEST_VIDEO" -o "$FIX/trimmed.mp4" --start 0 --end 0.5 \
      && [[ -s "$FIX/trimmed.mp4" ]]; then
      pass "trim-media"
    else
      fail "trim-media"
    fi

    if "$ROOT/bin/compress-video" "$TEST_VIDEO" -o "$FIX/video_compressed.mp4" -q 32 \
      && [[ -s "$FIX/video_compressed.mp4" ]]; then
      pass "compress-video"
    else
      fail "compress-video"
    fi
  else
    skip "video tools (could not create test video)"
  fi
else
  skip "video tools (ffmpeg not installed)"
fi

# ── Doctor ──────────────────────────────────────────────────────────────────────

if "$ROOT/bin/mango-doctor" --quick &>/dev/null; then
  pass "mango-doctor --quick"
else
  fail "mango-doctor --quick"
fi

echo ""
if [[ "$FAIL" -eq 0 ]]; then
  echo "All smoke tests passed (${#ALL_TOOLS[@]} tools)."
else
  echo "Some tests failed."
  exit 1
fi
