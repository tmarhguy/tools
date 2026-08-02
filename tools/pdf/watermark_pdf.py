#!/usr/bin/env python3
"""Add a text watermark to every page of a PDF."""
import argparse
import os
import sys

import fitz


def main() -> int:
    parser = argparse.ArgumentParser(description="Watermark a PDF with text")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output", required=True, help="Output PDF")
    parser.add_argument("-t", "--text", default="CONFIDENTIAL", help="Watermark text")
    parser.add_argument("--opacity", type=float, default=0.25, help="Opacity 0–1 (default: 0.25)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    opacity = max(0.05, min(1.0, args.opacity))
    gray = 1.0 - opacity

    doc = fitz.open(args.input)
    for page in doc:
        rect = page.rect
        fontsize = min(rect.width, rect.height) / 10
        center = fitz.Point(rect.width / 2, rect.height / 2)
        morph = (center, fitz.Matrix(1, 1).prerotate(45))
        page.insert_text(
            center,
            args.text,
            fontsize=fontsize,
            fontname="helv",
            color=(gray, gray, gray),
            morph=morph,
            overlay=True,
        )

    doc.save(args.output)
    doc.close()
    print(f"Wrote {args.output} (watermarked: {args.text!r})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
