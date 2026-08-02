#!/usr/bin/env python3
"""Combine images into a single PDF."""
import argparse
import os
import sys

from PIL import Image


def main() -> int:
    parser = argparse.ArgumentParser(description="Images to PDF")
    parser.add_argument("inputs", nargs="+", help="Image files")
    parser.add_argument("-o", "--output", required=True, help="Output PDF")
    args = parser.parse_args()

    images = []
    for path in args.inputs:
        if not os.path.isfile(path):
            print(f"Error: not found: {path}", file=sys.stderr)
            return 1
        img = Image.open(path)
        if img.mode in ("RGBA", "P"):
            bg = Image.new("RGB", img.size, (255, 255, 255))
            if img.mode == "P":
                img = img.convert("RGBA")
            bg.paste(img, mask=img.split()[3] if img.mode == "RGBA" else None)
            img = bg
        else:
            img = img.convert("RGB")
        images.append(img)

    if len(images) == 1:
        images[0].save(args.output, "PDF", resolution=150.0)
    else:
        first, *rest = images
        first.save(args.output, "PDF", resolution=150.0, save_all=True, append_images=rest)

    print(f"Wrote {args.output} ({len(images)} image(s))")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
