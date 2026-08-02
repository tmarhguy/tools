#!/usr/bin/env python3
"""Compress raster images (JPEG, PNG, WebP, GIF)."""
import argparse
import os
import sys

from PIL import Image


def main() -> int:
    parser = argparse.ArgumentParser(description="Compress images")
    parser.add_argument("input", help="Input image")
    parser.add_argument("-o", "--output", help="Output path (default: in-place)")
    parser.add_argument("-q", "--quality", type=int, default=85, help="Quality 1-100")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    ext = os.path.splitext(args.input)[1].lower()
    output = args.output or args.input

    img = Image.open(args.input)
    if img.mode in ("RGBA", "LA", "P"):
        img = img.convert("RGBA")
    else:
        img = img.convert("RGB")

    out_ext = os.path.splitext(output)[1].lower() or ext
    quality = max(1, min(100, args.quality))

    save_kw: dict = {}
    if out_ext in (".jpg", ".jpeg"):
        if img.mode == "RGBA":
            bg = Image.new("RGB", img.size, (255, 255, 255))
            bg.paste(img, mask=img.split()[3])
            img = bg
        save_kw = {"quality": quality, "optimize": True}
        fmt = "JPEG"
    elif out_ext == ".webp":
        save_kw = {"quality": quality, "method": 6}
        fmt = "WEBP"
    elif out_ext == ".png":
        save_kw = {"optimize": True, "compress_level": 9}
        fmt = "PNG"
    elif out_ext == ".gif":
        fmt = "GIF"
        save_kw = {"optimize": True}
    else:
        print(f"Error: unsupported format {out_ext}", file=sys.stderr)
        return 1

    before = os.path.getsize(args.input)
    img.save(output, format=fmt, **save_kw)
    after = os.path.getsize(output)
    pct = (1 - after / before) * 100 if before else 0
    print(f"Wrote {output} ({before:,} → {after:,} bytes, {pct:.1f}% smaller)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
