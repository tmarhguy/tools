#!/usr/bin/env python3
"""Merge multiple PDF files."""

import argparse
import glob
import os
import sys

from pypdf import PdfWriter


def collect_inputs(paths: list[str]) -> list[str]:
    files: list[str] = []
    for path in paths:
        if os.path.isdir(path):
            files.extend(sorted(glob.glob(os.path.join(path, "*.pdf"))))
        elif "*" in path or "?" in path:
            files.extend(sorted(glob.glob(path)))
        elif os.path.isfile(path):
            files.append(path)
    return files


def main() -> int:
    parser = argparse.ArgumentParser(description="Merge PDF files.")
    parser.add_argument("inputs", nargs="+", help="PDF files to merge (or one file + others in same dir)")
    parser.add_argument("-o", "--output", required=True, help="Output PDF path")
    args = parser.parse_args()

    files = collect_inputs(args.inputs)
    if len(files) == 1:
        folder = os.path.dirname(os.path.abspath(files[0]))
        files = sorted(glob.glob(os.path.join(folder, "*.pdf")))

    if len(files) < 2:
        print("Error: need at least 2 PDF files to merge.", file=sys.stderr)
        return 1

    writer = PdfWriter()
    for path in files:
        writer.append(path)
    os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
    with open(args.output, "wb") as fh:
        writer.write(fh)

    print(f"Merged {len(files)} files → {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
