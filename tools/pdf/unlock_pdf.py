#!/usr/bin/env python3
"""Remove password protection from a PDF."""
import argparse
import getpass
import os
import sys

from pypdf import PdfReader, PdfWriter


def main() -> int:
    parser = argparse.ArgumentParser(description="Unlock a password-protected PDF")
    parser.add_argument("input", help="Input PDF")
    parser.add_argument("-o", "--output", required=True, help="Output PDF")
    parser.add_argument("-p", "--password", help="PDF password (prompted if omitted)")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: not found: {args.input}", file=sys.stderr)
        return 1

    password = args.password
    if not password:
        password = getpass.getpass("PDF password: ")

    reader = PdfReader(args.input)
    if reader.is_encrypted:
        result = reader.decrypt(password or "")
        if result == 0:
            print("Error: incorrect password", file=sys.stderr)
            return 1

    writer = PdfWriter()
    for page in reader.pages:
        writer.add_page(page)

    with open(args.output, "wb") as f:
        writer.write(f)

    print(f"Wrote {args.output} (unlocked)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
