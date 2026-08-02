#!/usr/bin/env python3
"""Password-protect a PDF."""
import argparse
import getpass
import os
import sys

from pypdf import PdfReader, PdfWriter


def main() -> int:
    parser = argparse.ArgumentParser(description="Password-protect a PDF")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output", required=True, help="Output PDF")
    parser.add_argument("-p", "--password", help="Open password (prompted if omitted)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    password = args.password
    if not password:
        password = getpass.getpass("PDF password: ")
        confirm = getpass.getpass("Confirm password: ")
        if password != confirm:
            print("Error: passwords do not match", file=sys.stderr)
            return 1
    if not password:
        print("Error: password is required", file=sys.stderr)
        return 1

    reader = PdfReader(args.input)
    if reader.is_encrypted:
        print("Error: PDF is already encrypted — unlock it first", file=sys.stderr)
        return 1

    writer = PdfWriter()
    for page in reader.pages:
        writer.add_page(page)
    writer.encrypt(password)

    with open(args.output, "wb") as f:
        writer.write(f)

    print(f"Wrote {args.output} (password protected)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
