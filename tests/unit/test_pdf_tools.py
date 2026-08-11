"""Unit tests for PDF CLI tools."""

from __future__ import annotations

from pathlib import Path

from conftest import run_tool
from pypdf import PdfWriter


def _blank_pdf(path: Path) -> None:
    writer = PdfWriter()
    writer.add_blank_page(100, 100)
    with path.open("wb") as fh:
        writer.write(fh)


def test_merge_pdf(bin_dir: Path, tmp_path: Path) -> None:
    a = tmp_path / "a.pdf"
    b = tmp_path / "b.pdf"
    out = tmp_path / "merged.pdf"
    _blank_pdf(a)
    _blank_pdf(b)

    result = run_tool(bin_dir, "merge-pdf", str(a), str(b), "-o", str(out))
    assert result.returncode == 0, result.stderr
    assert out.is_file()
    assert out.stat().st_size > 0


def test_rotate_pdf(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "in.pdf"
    out = tmp_path / "rotated.pdf"
    _blank_pdf(inp)

    result = run_tool(bin_dir, "rotate-pdf", str(inp), "-o", str(out))
    assert result.returncode == 0, result.stderr
    assert out.is_file()


def test_protect_and_unlock_pdf(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "in.pdf"
    locked = tmp_path / "locked.pdf"
    unlocked = tmp_path / "unlocked.pdf"
    _blank_pdf(inp)

    lock = run_tool(bin_dir, "protect-pdf", str(inp), "-o", str(locked), "-p", "secret")
    assert lock.returncode == 0, lock.stderr

    unlock = run_tool(bin_dir, "unlock-pdf", str(locked), "-o", str(unlocked), "-p", "secret")
    assert unlock.returncode == 0, unlock.stderr
    assert unlocked.is_file()
