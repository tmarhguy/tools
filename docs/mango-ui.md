# Mango — Interface Guide

![interface](https://img.shields.io/badge/interface-terminal_TUI-2563EB?style=for-the-badge)
![offline](https://img.shields.io/badge/offline-first-3776AB?style=for-the-badge)

How the interactive hub works: menus, the file browser, and a conversion from start to finish.

Not set up yet? **[Installation & Setup](install.md)**

---

## Table of Contents

- [Launch](#launch)
- [Main menu](#main-menu)
- [Folder browser](#folder-browser)
- [Conversion flow](#conversion-flow)
- [Quick Convert](#quick-convert)
- [Keys](#keys)
- [Related](#related)

---

## Launch

```bash
mango          # from anywhere, after setup --link
./mango        # from the repo root
```

Needs a real terminal (TTY). It will not run when piped.

---

## Main menu

**↑↓** to move, **Enter** to select. **●** ready · **○** coming soon.

<p align="center">
  <img src="../media/main_menu.png" alt="Mango main menu — arrow navigation" width="520">
</p>

| Option | What it does |
|--------|----------------|
| **Quick Convert** | Pick a file first, then choose a conversion for that type |
| **Video & Audio** | GIF, compress, extract audio, trim |
| **PDF Toolkit** | Convert, merge, split, rotate, compress |
| **Image Toolkit** | Compress, convert formats, strip EXIF |
| **Developer** | JSON, CSV, base64, hashes |
| **Exit** | Leave Mango |

---

## Folder browser

Mango lists only folders that contain matching files, plus matches in the current directory. **Enter** opens a folder or selects a file. **`../`** goes up. **P** to paste or drag-and-drop a path.

<p align="center">
  <img src="../media/dir_navig.png" alt="Mango folder browser — filtered folders and files" width="720">
</p>

Run `mango` from the folder you are working in so the browser starts there.

---

## Conversion flow

Preview the paths, confirm, watch it run, then get the saved path and size.

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

## Quick Convert

Pick the file first. Mango lists every conversion registered for that extension.

Example: `report.pdf` → PDF → Word, split, rotate, JPG export, compress.

---

## Keys

| Key | Where | Action |
|-----|--------|--------|
| **↑↓** | Menus and browser | Move |
| **Enter** | Menus and browser | Select / open |
| **P** | File browser | Type or paste a path |
| **Q** | Menus and browser | Back / cancel |

---

## Related

- [install.md](install.md) — setup, PATH, and dependencies
- [Readme.md](../Readme.md) — overview and full tool list
