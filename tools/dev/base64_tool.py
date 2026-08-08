#!/usr/bin/env python3
"""Base64 encode or decode a file."""

import argparse
import base64
import os
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description="Base64 encode/decode a file.")
    parser.add_argument("input", help="Input file path")
    parser.add_argument("-o", "--output", help="Output file path")
    parser.add_argument("-d", "--decode", action="store_true", help="Decode instead of encode")
    args = parser.parse_args()

    if not os.path.isfile(args.input):
        print(f"Error: file not found: {args.input}", file=sys.stderr)
        return 1

    with open(args.input, "rb") as fh:
        data = fh.read()

    if args.decode:
        try:
            out = base64.b64decode(data, validate=True)
        except Exception as exc:
            print(f"Error: invalid base64 input: {exc}", file=sys.stderr)
            return 1
    else:
        out = base64.encodebytes(data)

    if args.output:
        os.makedirs(os.path.dirname(os.path.abspath(args.output)) or ".", exist_ok=True)
        with open(args.output, "wb") as fh:
            fh.write(out)
        print(f"Saved: {args.output}")
    else:
        sys.stdout.buffer.write(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
