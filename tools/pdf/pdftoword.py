#!/usr/bin/env python3
"""Convert PDF to DOCX using pdf2docx."""
import argparse
import os
import sys

from pdf2docx import Converter


def main() -> int:
    parser = argparse.ArgumentParser(description="PDF to Word (DOCX)")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output", required=True, help="Output DOCX")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    cv = Converter(args.input)
    try:
        cv.convert(args.output)
    finally:
        cv.close()

    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
