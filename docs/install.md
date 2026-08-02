# Mango — Installation & Setup

![status](https://img.shields.io/badge/status-active_development-2ea043?style=for-the-badge)
![platform](https://img.shields.io/badge/platform-macOS_|_Linux_|_Windows-2563EB?style=for-the-badge)
![python](https://img.shields.io/badge/python-3.9+-3776AB?style=for-the-badge)

Get Mango running locally in a few minutes.

<p align="center">
  <img src="../media/title_screen_mango.png" alt="Mango — My Toolkit Hub" width="720">
</p>

---

## Table of Contents

- [Quick start](#quick-start)
- [Setup script](#setup-script)
- [What you need](#what-you-need)
- [Step-by-step setup](#step-by-step-setup)
- [Verify your install](#verify-your-install)
- [Add Mango to your PATH](#add-mango-to-your-path)
- [Platform notes](#platform-notes)
- [Optional dependencies](#optional-dependencies)
- [What each tool needs](#what-each-tool-needs)
- [Troubleshooting](#troubleshooting)
- [Related](#related)

---

## What you need

| Requirement | Used for |
|-------------|----------|
| **Python 3.9+** | PDF, image, and developer tools |
| **pip + venv** | Installing Python packages in an isolated environment |
| **ffmpeg** | Video → GIF, extract audio, trim media |
| **Ghostscript** *(optional)* | PDF compression only |

Developer tools (JSON, CSV, base64, hashes) need **Python only** — no extra packages beyond the stdlib.

---

## Quick start

**One-liner** (no manual clone — installs to `~/.local/share/mango`):

```bash
curl -fsSL https://raw.githubusercontent.com/tmarhguy/tools/main/setup.sh | bash
```

**From a clone:**

```bash
git clone https://github.com/tmarhguy/tools.git
cd tools
./setup.sh
```

The setup script creates the venv, installs Python packages, makes scripts executable, optionally installs `ffmpeg`, runs `mango doctor`, and can symlink `mango` to `~/.local/bin`.

Non-interactive: `./setup.sh --yes`

---

## Setup script

[`setup.sh`](../setup.sh) automates the full install.

| Mode | Command |
|------|---------|
| **One-liner** | `curl -fsSL https://raw.githubusercontent.com/tmarhguy/tools/main/setup.sh \| bash` |
| **From clone** | `./setup.sh` |
| **Non-interactive** | `./setup.sh --yes` |
| **Skip ffmpeg prompt** | `./setup.sh --no-ffmpeg` |
| **Add to PATH** | `./setup.sh --link` |

**Install location:** `~/.local/share/mango` (override with `MANGO_INSTALL_DIR`)

## Step-by-step setup

Manual install (alternative to `setup.sh`):

### 1. Clone the repository

```bash
git clone https://github.com/tmarhguy/tools.git
cd tools
```

### 2. Create a virtual environment

Keeps Mango's Python packages separate from your system Python.

```bash
python3 -m venv .venv
source .venv/bin/activate          # macOS / Linux
# .venv\Scripts\activate           # Windows
```

You should see `(.venv)` in your prompt. Re-run `source .venv/bin/activate` whenever you open a new terminal.

### 3. Install Python dependencies

```bash
pip install -r requirements.txt
```

This installs **Pillow**, **pypdf**, **pdf2docx**, and **pymupdf** — the backends for image and PDF tools.

### 4. Install system tools

**ffmpeg** (required for video & audio):

```bash
brew install ffmpeg                # macOS
sudo apt install ffmpeg            # Ubuntu / Debian
winget install Gyan.FFmpeg         # Windows
```

**Ghostscript** (optional — only for `compress-pdf`):

```bash
brew install ghostscript           # macOS
sudo apt install ghostscript       # Linux
winget install Artifex.GhostScript # Windows
```

### 5. Launch Mango

```bash
./mango              # interactive UI
./mango doctor       # dependency check only
```

<p align="center">
  <img src="../media/full_ui_start_page.png" alt="Mango full start page" width="800">
</p>

<table>
  <tr>
    <td align="center" width="50%">
      <strong>Main menu</strong><br>
      <sub>Pick a category</sub>
      <br><br>
      <img src="../media/main_menu.png" alt="Main menu" width="380">
    </td>
    <td align="center" width="50%">
      <strong>Enter choice</strong><br>
      <sub>Type <code>1</code>–<code>6</code></sub>
      <br><br>
      <img src="../media/enter_choice.png" alt="Choice prompt" width="380">
    </td>
  </tr>
</table>

Interface walkthrough: [mango-ui.md](mango-ui.md)

---

## Verify your install

```bash
./mango doctor
```

`mango doctor` checks Python, your venv, pip packages, and system commands. It prints **fix commands** for anything missing.

Example output when healthy:

```
  ✔ Python: Python 3.x.x (.venv/bin/python)
  ✔ Virtual env: .../tools/.venv
  ✔ Python package: Pillow
  ...
  ✔ Command: ffmpeg
```

---

## Add Mango to your PATH

To run `mango`, `to_gif`, and other tools from any directory:

```bash
export PATH="$PATH:/path/to/tools/bin"
```

Add that line to your shell config (`.zshrc`, `.bashrc`, etc.) to make it permanent.

You can also run tools directly from the repo root:

```bash
./mango
./bin/to_gif video.mp4 -o out.gif
```

---

## Platform notes

### macOS

- Install [Homebrew](https://brew.sh) if you don't have it.
- `brew install python ffmpeg ghostscript`

### Linux (Debian / Ubuntu)

```bash
sudo apt update
sudo apt install python3 python3-venv python3-pip ffmpeg ghostscript
```

### Windows

- Install Python from [python.org](https://www.python.org/downloads/) (check **Add to PATH**).
- Use `winget` for ffmpeg and Ghostscript (see Quick start).
- Activate the venv with `.venv\Scripts\activate` in PowerShell or CMD.

---

## Optional dependencies

| Tool | Optional dep | Install |
|------|----------------|---------|
| `compress-pdf` | Ghostscript (`gs`) | `brew install ghostscript` |

All other shipped tools work without Ghostscript.

---

## What each tool needs

| Category | Tools | Dependencies |
|----------|-------|----------------|
| **Video & Audio** | GIF, extract audio, trim | `ffmpeg` |
| **Image** | compress, convert, strip EXIF | Python + `Pillow` |
| **PDF** | merge, split, rotate, jpg→pdf | Python + `pypdf` |
| **PDF** | PDF → Word | Python + `pdf2docx` |
| **PDF** | PDF → JPG | Python + `pymupdf` |
| **PDF** | compress | Ghostscript (`gs`) |
| **Developer** | JSON, CSV, base64, hash | Python 3 stdlib only |

Run any tool with `--help` for usage:

```bash
./bin/format-json --help
./bin/merge-pdf --help
```

---

## Troubleshooting

**Setup script fails on `curl | bash`**

Ensure `git` and `python3` are installed. Re-run with:

```bash
curl -fsSL https://raw.githubusercontent.com/tmarhguy/tools/main/setup.sh | bash -s -- --yes
```

**`mango doctor` reports a missing Python package**

```bash
./setup.sh --yes
# or manually:
source .venv/bin/activate
pip install -r requirements.txt
```

**`ffmpeg` not found**

Install via your package manager (see [Platform notes](#platform-notes)), then re-run `./mango doctor`.

**`Permission denied` when running `./mango`**

```bash
chmod +x mango bin/*
```

**PDF → Word produces garbled output**

Works best on **text-based** PDFs. Scanned/image PDFs need OCR (not yet supported).

**Mango says "interactive terminal UI" and exits**

Run `./mango` directly in a terminal — it doesn't work when piped or run from a non-TTY environment.

---

## Related

- [Readme.md](../Readme.md) — overview and full tool list
- [mango-ui.md](mango-ui.md) — interface guide
- [setup.sh](../setup.sh) — automated install script
