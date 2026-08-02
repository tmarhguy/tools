#!/usr/bin/env python3
"""Rotate PDF pages."""
import argparse
import os
import sys

from pypdf import PdfReader, PdfWriter


def main() -> int:
    parser = argparse.ArgumentParser(description="Rotate PDF")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output", required=True, help="Output PDF")
    parser.add_argument("-r", "--rotate", type=int, default=90, choices=[90, 180, 270], help="Degrees")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    reader = PdfReader(args.input)
    writer = PdfWriter()
    for page in reader.pages:
        page.rotate(args.rotate)
        writer.add_page(page)

    with open(args.output, "wb") as f:
        writer.write(f)
    print(f"Wrote {args.output} (rotated {args.rotate}°)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
