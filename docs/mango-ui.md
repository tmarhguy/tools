# Mango — Interface Guide

![status](https://img.shields.io/badge/status-active_development-2ea043?style=for-the-badge)
![interface](https://img.shields.io/badge/interface-terminal_TUI-2563EB?style=for-the-badge)
![offline](https://img.shields.io/badge/offline-first-3776AB?style=for-the-badge)

Mango is the interactive front-end for this toolkit. One command, guided prompts — no memorizing script names or flags.

<p align="center">
  <img src="../media/title_screen_mango.png" alt="Mango — My Toolkit Hub" width="720">
</p>

---

## Table of Contents

- [Launch](#launch)
- [Main menu](#main-menu)
- [Folder browser](#folder-browser)
- [Conversion flow](#conversion-flow)
- [How it works](#how-it-works)
- [Quick Convert](#quick-convert)
- [CLI alternative](#cli-alternative)
- [Tips](#tips)
- [Related](#related)

---

## Launch

```bash
./mango              # from the repo root
mango                # from anywhere (after ./setup.sh --link --yes)
./mango doctor       # dependency check only
```

Requires a real terminal (TTY). Mango won't run when piped or from non-interactive shells.

Not installed yet? See [install.md](install.md) or run `./setup.sh --link --yes`.

---

## Main menu

Navigate with **↑↓** and press **Enter** to select. **●** tools are ready; **○** are coming soon.

<p align="center">
  <img src="../media/main_menu.png" alt="Mango main menu — arrow navigation" width="520">
</p>

| Option | Description |
|--------|-------------|
| **Quick Convert** | Pick a file first → see all conversions for that type |
| **Video & Audio** | GIF, extract audio, trim |
| **PDF Toolkit** | Convert, merge, split, rotate, compress |
| **Image Toolkit** | Compress, convert formats, strip EXIF |
| **Developer** | JSON, CSV, base64, hashes |
| **Exit** | Leave Mango |

---

## Folder browser

When you pick a tool, Mango shows only **folders that contain matching files** — plus any matches in the current directory. Open a folder with **Enter**, go up with **`../`**, or press **P** to type a path manually.

<p align="center">
  <img src="../media/dir_navig.png" alt="Mango folder browser — filtered folders and files" width="720">
</p>

| Key | Action |
|-----|--------|
| **↑↓** | Navigate the list |
| **Enter** | Open a folder or select a file |
| **P** | Type a path manually |
| **Q** | Go back / cancel |

---

## Conversion flow

After you pick a file, Mango previews the conversion, runs the tool, and reports the result.

<table>
  <tr>
    <td align="center" width="33%">
      <strong>Preview</strong><br>
      <sub>Confirm before running</sub>
      <br><br>
      <img src="../media/img_comp_window.png" alt="Compress image — ready to convert" width="380">
    </td>
    <td align="center" width="33%">
      <strong>Running</strong><br>
      <sub>Live status</sub>
      <br><br>
      <img src="../media/running_img_compress.png" alt="Compress image — executing" width="380">
    </td>
    <td align="center" width="33%">
      <strong>Done</strong><br>
      <sub>Saved path and size</sub>
      <br><br>
      <img src="../media/success_image_compress.png" alt="Compress image — success" width="380">
    </td>
  </tr>
</table>

---

## How it works

1. **Launch** — `mango` from any directory
2. **Choose** — a category from the main menu, or **Quick Convert**
3. **Browse** — arrow through folders; only relevant files and folders are shown
4. **Preview** — confirm input → output paths
5. **Run** — Mango executes the underlying `bin/` tool
6. **Return** — press Enter to go back to the menu

---

## Quick Convert

The fastest path: select your file first, then Mango lists every conversion available for that extension.

Example: pick `report.pdf` → see PDF → Word, split, rotate, JPG export, etc.

---

## CLI alternative

Every tool is also available directly — useful for scripts and automation:

```bash
./bin/to_gif video.mp4 -o out.gif
./bin/to_gif video.mp4 -o out.gif -w 720 --fps 15 -c 192 -l 38
./bin/merge-pdf a.pdf b.pdf -o merged.pdf
./bin/format-json data.json -o pretty.json
./bin/compress-image photo.jpg -o photo-small.jpg
```

Run any tool with `--help` for flags.

---

## Tips

| Tip | Detail |
|-----|--------|
| **Browse anywhere** | Run `mango` from the folder you're working in — no need to move files |
| **Folder filter** | Subfolders only appear if they contain files for the current tool |
| **Type a path** | Press **P** in the file browser to paste or drag & drop a path |
| **Go back** | **Q** at a menu or file picker returns to the previous screen |
| **Check deps** | `mango doctor` before your first conversion |
| **Global install** | `./setup.sh --link --yes` puts all commands on your PATH |

---

## Related

- [Readme.md](../Readme.md) — overview and full tool list
- [install.md](install.md) — setup, `setup.sh`, and dependencies
- [setup.sh](../setup.sh) — automated install script
