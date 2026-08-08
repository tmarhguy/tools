#!/usr/bin/env python3
"""Split a PDF into single-page files or a page range."""

import argparse
import os
import sys

from pypdf import PdfReader, PdfWriter


def main() -> int:
    parser = argparse.ArgumentParser(description="Split a PDF into pages.")
    parser.add_argument("input", help="Input PDF path")
    parser.add_argument("-o", "--output", required=True, help="Output directory or file pattern")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    reader = PdfReader(args.input)
    base = os.path.splitext(os.path.basename(args.input))[0]

    if os.path.isdir(args.output) or args.output.endswith(os.sep):
        out_dir = args.output.rstrip(os.sep)
        os.makedirs(out_dir, exist_ok=True)
        for i, page in enumerate(reader.pages, start=1):
            writer = PdfWriter()
            writer.add_page(page)
            out_path = os.path.join(out_dir, f"{base}-page{i:03d}.pdf")
            with open(out_path, "wb") as fh:
                writer.write(fh)
        print(f"Saved {len(reader.pages)} pages → {out_dir}/")
        return 0

    out_dir = os.path.dirname(os.path.abspath(args.output)) or "."
    os.makedirs(out_dir, exist_ok=True)
    stem, _ = os.path.splitext(os.path.basename(args.output))
    for i, page in enumerate(reader.pages, start=1):
        writer = PdfWriter()
        writer.add_page(page)
        out_path = os.path.join(out_dir, f"{stem}-page{i:03d}.pdf")
        with open(out_path, "wb") as fh:
            writer.write(fh)
    print(f"Saved {len(reader.pages)} pages → {out_dir}/")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
