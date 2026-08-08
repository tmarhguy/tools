#!/usr/bin/env python3
"""Strip EXIF and other metadata from images."""

import argparse
import os
import sys

from PIL import Image


def strip_metadata(path: str, output: str) -> None:
    img = Image.open(path)
    data = list(img.getdata())
    clean = Image.new(img.mode, img.size)
    clean.putdata(data)
    ext = os.path.splitext(output)[1].lower().lstrip(".")
    if ext in ("jpg", "jpeg"):
        if clean.mode in ("RGBA", "P"):
            clean = clean.convert("RGB")
        clean.save(output, "JPEG", quality=95, optimize=True)
    else:
        clean.save(output)


def main() -> int:
    parser = argparse.ArgumentParser(description="Strip EXIF/metadata from an image.")
    parser.add_argument("input", help="Input image path")
    parser.add_argument("-o", "--output", help="Output path (default: overwrite input)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    output = args.output or args.input
    os.makedirs(os.path.dirname(os.path.abspath(output)) or ".", exist_ok=True)
    strip_metadata(args.input, output)
    print(f"Saved: {output} (metadata removed)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
