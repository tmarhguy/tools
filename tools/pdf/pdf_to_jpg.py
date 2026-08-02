#!/usr/bin/env python3
"""Render PDF pages to JPG images."""
import argparse
import os
import sys

import fitz  # pymupdf


def main() -> int:
    parser = argparse.ArgumentParser(description="PDF to JPG")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output-dir", required=True, help="Output directory")
    parser.add_argument("-d", "--dpi", type=int, default=150, help="Render DPI")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    os.makedirs(args.output_dir, exist_ok=True)
    base = os.path.splitext(os.path.basename(args.input))[0]
    doc = fitz.open(args.input)
    zoom = args.dpi / 72
    matrix = fitz.Matrix(zoom, zoom)

    for i, page in enumerate(doc):
        pix = page.get_pixmap(matrix=matrix, alpha=False)
        out = os.path.join(args.output_dir, f"{base}_page_{i + 1:03d}.jpg")
        pix.save(out)

    print(f"Wrote {len(doc)} page(s) to {args.output_dir}/")
    doc.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
