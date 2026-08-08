#!/usr/bin/env python3
"""Rotate PDF pages."""

import argparse
import os
import sys

from pypdf import PdfReader, PdfWriter


def main() -> int:
    parser = argparse.ArgumentParser(description="Rotate PDF pages.")
    parser.add_argument("input", help="Input PDF path")
    parser.add_argument("-o", "--output", required=True, help="Output PDF path")
    parser.add_argument("-r", "--rotate", type=int, default=90, choices=(90, 180, 270),
                        help="Rotation in degrees (default: 90)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    reader = PdfReader(args.input)
    writer = PdfWriter()
    for page in reader.pages:
        page.rotate(args.rotate)
        writer.add_page(page)

    os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
    with open(args.output, "wb") as fh:
        writer.write(fh)

    print(f"Saved: {args.output} (rotated {args.rotate}°)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
