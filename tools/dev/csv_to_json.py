#!/usr/bin/env python3
"""Convert CSV to JSON array."""
import argparse
import csv
import json
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert CSV to JSON")
    parser.add_argument("input", help="Input CSV file")
    parser.add_argument("-o", "--output", help="Output JSON file")
    args = parser.parse_args()

    with open(args.input, newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    text = json.dumps(rows, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(text)
        print(f"Wrote {args.output} ({len(rows)} rows)")
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
