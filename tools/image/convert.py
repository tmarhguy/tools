#!/usr/bin/env python3
"""Convert between raster image formats."""

import argparse
import os
import sys

from PIL import Image

FORMAT_MAP = {
    "jpg": "JPEG",
    "jpeg": "JPEG",
    "png": "PNG",
    "webp": "WEBP",
    "gif": "GIF",
    "bmp": "BMP",
}


def convert(path: str, output: str, fmt: str) -> None:
    img = Image.open(path)
    if fmt == "JPEG" and img.mode in ("RGBA", "P"):
        img = img.convert("RGB")
    save_kw = {}
    if fmt == "JPEG":
        save_kw = {"quality": 90, "optimize": True}
    elif fmt == "WEBP":
        save_kw = {"quality": 90, "method": 6}
    img.save(output, fmt, **save_kw)


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert image format.")
    parser.add_argument("input", help="Input image path")
    parser.add_argument("-o", "--output", required=True, help="Output image path")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    ext = os.path.splitext(args.output)[1].lower().lstrip(".")
    fmt = FORMAT_MAP.get(ext)
    if not fmt:
        print(f"Error: unsupported output format .{ext}", file=sys.stderr)
        return 1

    os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
    convert(args.input, args.output, fmt)
    print(f"Saved: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
