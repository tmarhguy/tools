#!/usr/bin/env python3
"""Compress PDF via Ghostscript."""

import argparse
import os
import shutil
import subprocess
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description="Compress a PDF file.")
    parser.add_argument("input", help="Input PDF path")
    parser.add_argument("-o", "--output", required=True, help="Output PDF path")
    parser.add_argument("-q", "--quality", choices=("screen", "ebook", "printer", "prepress"),
                        default="ebook", help="Compression preset (default: ebook)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    gs = shutil.which("gs")
    if not gs:
        print("Error: ghostscript (gs) not found. Install: brew install ghostscript", file=sys.stderr)
        return 1

    os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
    before = os.path.getsize(args.input)
    cmd = [
        gs, "-sDEVICE=pdfwrite", "-dCompatibilityLevel=1.4",
        f"-dPDFSETTINGS=/{args.quality}", "-dNOPAUSE", "-dQUIET", "-dBATCH",
        f"-sOutputFile={args.output}", args.input,
    ]
    subprocess.run(cmd, check=True)
    after = os.path.getsize(args.output)
    pct = (1 - after / before) * 100 if before else 0
    print(f"Saved: {args.output} ({after:,} B, {pct:.0f}% smaller)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
