#!/usr/bin/env python3
"""Export PDF pages as JPG images."""

import argparse
import os
import sys

import fitz  # pymupdf


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert PDF pages to JPG.")
    parser.add_argument("input", help="Input PDF path")
    parser.add_argument("-o", "--output", required=True, help="Output directory")
    parser.add_argument("-d", "--dpi", type=int, default=150, help="Render DPI (default: 150)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    out_dir = args.output.rstrip(os.sep)
    os.makedirs(out_dir, exist_ok=True)
    base = os.path.splitext(os.path.basename(args.input))[0]
    doc = fitz.open(args.input)
    zoom = args.dpi / 72.0
    matrix = fitz.Matrix(zoom, zoom)

    for i, page in enumerate(doc, start=1):
        pix = page.get_pixmap(matrix=matrix, alpha=False)
        out_path = os.path.join(out_dir, f"{base}-page{i:03d}.jpg")
        pix.save(out_path)

    print(f"Saved {doc.page_count} JPG(s) → {out_dir}/")
    doc.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
