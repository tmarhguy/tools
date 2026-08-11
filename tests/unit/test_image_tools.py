"""Unit tests for image CLI tools."""

from __future__ import annotations

from pathlib import Path

from conftest import run_tool
from PIL import Image


def _sample_png(path: Path) -> None:
    Image.new("RGB", (32, 32), color=(255, 128, 0)).save(path)


def test_compress_image(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "in.png"
    out = tmp_path / "out.png"
    _sample_png(inp)

    result = run_tool(bin_dir, "compress-image", str(inp), "-o", str(out))
    assert result.returncode == 0, result.stderr
    assert out.is_file()
    assert out.stat().st_size > 0


def test_convert_image_to_webp(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "in.png"
    out = tmp_path / "out.webp"
    _sample_png(inp)

    result = run_tool(bin_dir, "convert-image", str(inp), "-o", str(out))
    assert result.returncode == 0, result.stderr
    assert out.is_file()


def test_strip_exif(bin_dir: Path, tmp_path: Path) -> None:
    inp = tmp_path / "in.jpg"
    out = tmp_path / "out.jpg"
    Image.new("RGB", (32, 32), color=(10, 20, 30)).save(inp, quality=90)

    result = run_tool(bin_dir, "strip-exif", str(inp), "-o", str(out))
    assert result.returncode == 0, result.stderr
    assert out.is_file()
