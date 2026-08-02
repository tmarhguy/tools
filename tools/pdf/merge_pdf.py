#!/usr/bin/env python3
"""Merge multiple PDFs into one."""
import argparse
import os
import sys

from pypdf import PdfWriter


def main() -> int:
    parser = argparse.ArgumentParser(description="Merge PDFs")
    parser.add_argument("inputs", nargs="+", help="PDF files to merge")
    parser.add_argument("-o", "--output", required=True, help="Output PDF")
    args = parser.parse_args()

    writer = PdfWriter()
    for path in args.inputs:
        if not os.path.isfile(path):
            print(f"Error: not found: {path}", file=sys.stderr)
            return 1
        writer.append(path)

    with open(args.output, "wb") as f:
        writer.write(f)
    print(f"Wrote {args.output} ({len(args.inputs)} files merged)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
