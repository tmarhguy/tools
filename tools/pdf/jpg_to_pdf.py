#!/usr/bin/env python3
"""Convert images to a single PDF."""

import argparse
import os
import sys

import fitz  # pymupdf


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert images to PDF.")
    parser.add_argument("input", help="Input image path")
    parser.add_argument("-o", "--output", required=True, help="Output PDF path")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
    doc = fitz.open()
    img = fitz.open(args.input)
    rect = img[0].rect
    page = doc.new_page(width=rect.width, height=rect.height)
    page.insert_image(rect, filename=args.input)
    doc.save(args.output)
    doc.close()
    img.close()

    print(f"Saved: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
