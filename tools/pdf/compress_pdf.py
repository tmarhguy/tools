#!/usr/bin/env python3
"""Compress PDF via pymupdf (fallback when Ghostscript is unavailable)."""
import argparse
import os
import sys

import fitz


def main() -> int:
    parser = argparse.ArgumentParser(description="Compress PDF (pymupdf)")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output", required=True, help="Output PDF")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    before = os.path.getsize(args.input)
    doc = fitz.open(args.input)
    doc.save(args.output, garbage=4, deflate=True, clean=True)
    doc.close()
    after = os.path.getsize(args.output)
    pct = (1 - after / before) * 100 if before else 0
    print(f"Wrote {args.output} ({before:,} → {after:,} bytes, {pct:.1f}% change)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
