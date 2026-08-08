#!/usr/bin/env python3
"""Compress raster images with Pillow."""

import argparse
import os
import sys

from PIL import Image


def compress(path: str, output: str, quality: int) -> None:
    img = Image.open(path)
    ext = os.path.splitext(output)[1].lower().lstrip(".")

    if ext in ("jpg", "jpeg"):
        if img.mode in ("RGBA", "P"):
            img = img.convert("RGB")
        img.save(output, "JPEG", quality=quality, optimize=True)
    elif ext == "webp":
        img.save(output, "WEBP", quality=quality, method=6)
    elif ext == "png":
        img.save(output, "PNG", optimize=True, compress_level=9)
    elif ext == "gif":
        img.save(output, "GIF", optimize=True)
    else:
        img.save(output)


def main() -> int:
    parser = argparse.ArgumentParser(description="Compress an image file.")
    parser.add_argument("input", help="Input image path")
    parser.add_argument("-o", "--output", help="Output path (default: overwrite input)")
    parser.add_argument("-q", "--quality", type=int, default=85, help="JPEG/WebP quality 1-100")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    output = args.output or args.input
    os.makedirs(os.path.dirname(os.path.abspath(output)) or ".", exist_ok=True)

    before = os.path.getsize(args.input)
    compress(args.input, output, max(1, min(100, args.quality)))
    after = os.path.getsize(output)

    pct = (1 - after / before) * 100 if before else 0
    print(f"Saved: {output} ({after:,} B, {pct:.0f}% smaller)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
