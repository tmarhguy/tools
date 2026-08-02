#!/usr/bin/env python3
"""Convert image between raster formats."""
import argparse
import os
import sys

from PIL import Image


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert image format")
    parser.add_argument("input", help="Input image")
    parser.add_argument("-o", "--output", required=True, help="Output image")
    parser.add_argument("-f", "--format", help="Output format (jpg, png, webp, gif)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    out_ext = os.path.splitext(args.output)[1].lower().lstrip(".")
    fmt = (args.format or out_ext or "png").upper()
    if fmt == "JPG":
        fmt = "JPEG"

    img = Image.open(args.input)
    if fmt == "JPEG" and img.mode in ("RGBA", "P", "LA"):
        bg = Image.new("RGB", img.size, (255, 255, 255))
        if img.mode == "P":
            img = img.convert("RGBA")
        bg.paste(img, mask=img.split()[3] if "A" in img.mode else None)
        img = bg

    img.save(args.output, format=fmt)
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
