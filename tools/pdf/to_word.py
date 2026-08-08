#!/usr/bin/env python3
"""PDF to Word (DOCX) conversion."""

import argparse
import os
import sys

from pdf2docx import Converter


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert PDF to Word DOCX.")
    parser.add_argument("input", help="Input PDF path")
    parser.add_argument("-o", "--output", required=True, help="Output DOCX path")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
    cv = Converter(args.input)
    try:
        cv.convert(args.output)
    finally:
        cv.close()

    print(f"Saved: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
