#!/usr/bin/env python3
"""Strip EXIF and metadata from images."""
import argparse
import os
import sys

from PIL import Image


def main() -> int:
    parser = argparse.ArgumentParser(description="Strip image metadata")
    parser.add_argument("input", help="Input image")
    parser.add_argument("-o", "--output", help="Output (default: in-place)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    output = args.output or args.input
    img = Image.open(args.input)
    data = list(img.getdata())
    clean = Image.new(img.mode, img.size)
    clean.putdata(data)
    ext = os.path.splitext(output)[1].lower()
    fmt = img.format or "PNG"
    if ext in (".jpg", ".jpeg"):
        fmt = "JPEG"
    elif ext == ".webp":
        fmt = "WEBP"
    clean.save(output, format=fmt)
    print(f"Wrote {output} (metadata removed)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
