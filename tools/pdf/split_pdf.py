#!/usr/bin/env python3
"""Split PDF into per-page files or a page range."""
import argparse
import os
import sys

from pypdf import PdfReader, PdfWriter


def main() -> int:
    parser = argparse.ArgumentParser(description="Split PDF")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output-dir", required=True, help="Output directory")
    parser.add_argument("--pages", help="Page range e.g. 1-3 (default: all pages, one file each)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    os.makedirs(args.output_dir, exist_ok=True)
    reader = PdfReader(args.input)
    total = len(reader.pages)

    if args.pages:
        start_s, _, end_s = args.pages.partition("-")
        start = int(start_s) - 1
        end = int(end_s or start_s) - 1
        indices = range(max(0, start), min(total, end + 1))
        writer = PdfWriter()
        for i in indices:
            writer.add_page(reader.pages[i])
        out = os.path.join(args.output_dir, "pages.pdf")
        with open(out, "wb") as f:
            writer.write(f)
        print(f"Wrote {out} ({len(indices)} pages)")
    else:
        base = os.path.splitext(os.path.basename(args.input))[0]
        for i, page in enumerate(reader.pages):
            writer = PdfWriter()
            writer.add_page(page)
            out = os.path.join(args.output_dir, f"{base}_page_{i + 1:03d}.pdf")
            with open(out, "wb") as f:
                writer.write(f)
        print(f"Wrote {total} pages to {args.output_dir}/")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
