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
- [Full start page](#full-start-page)
- [Main menu](#main-menu)
- [Choice prompt](#choice-prompt)
- [How it works](#how-it-works)
- [Quick Convert](#quick-convert)
- [CLI alternative](#cli-alternative)
- [Tips](#tips)
- [Related](#related)

---

## Launch

```bash
./mango              # from the repo root
mango                # if bin/ or ~/.local/bin is on your PATH
./mango doctor       # dependency check only
```

Requires a real terminal (TTY). Mango won't run when piped or from non-interactive shells.

Not installed yet? See [install.md](install.md) or run `./setup.sh`.

---

## Full start page

Everything on screen at launch — header, welcome panel, main menu, and choice prompt.

<p align="center">
  <img src="../media/full_ui_start_page.png" alt="Mango full start page" width="800">
</p>

---

## Main menu

Pick a toolkit category. **●** tools are ready; **○** are coming soon.

<p align="center">
  <img src="../media/main_menu.png" alt="Mango main menu" width="520">
</p>

| # | Option | Description |
|---|--------|-------------|
| **1** | Quick Convert | Pick a file first → see all conversions for that type |
| **2** | Video & Audio | GIF, extract audio, trim |
| **3** | PDF Toolkit | Convert, merge, split, rotate, compress |
| **4** | Image Toolkit | Compress, convert formats, strip EXIF |
| **5** | Developer | JSON, CSV, base64, hashes |
| **6** | Exit | Leave Mango |

---

## Choice prompt

Type a number to continue. On sub-screens, `q` goes back.

<p align="center">
  <img src="../media/enter_choice.png" alt="Mango enter choice prompt" width="520">
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

---

## How it works

1. **Launch** — `./mango`
2. **Choose** — a category from the main menu, or **Quick Convert**
3. **Pick a file** — drag & drop a path into the terminal, or type it (tab-completion enabled)
4. **Preview** — confirm input → output paths
5. **Run** — Mango executes the underlying `bin/` tool
6. **Return** — press Enter to go back to the menu

---

## Quick Convert

The fastest path: select your file first, then Mango lists every conversion available for that extension.

Example: drop `report.pdf` → see PDF → Word, split, rotate, JPG export, etc.

---

## CLI alternative

Every tool is also available directly — useful for scripts and automation:

```bash
./bin/to_gif video.mp4 -o out.gif
./bin/merge-pdf a.pdf b.pdf -o merged.pdf
./bin/format-json data.json -o pretty.json
./bin/compress-image photo.jpg -o photo-small.jpg
```

Run any tool with `--help` for flags.

---

## Tips

| Tip | Detail |
|-----|--------|
| **Drag & drop** | Drop a file from Finder into the terminal to paste its path |
| **Go back** | Type `q` at a menu prompt to return |
| **Check deps** | `./mango doctor` before your first conversion |
| **PATH** | `./setup.sh --link` adds `mango` to `~/.local/bin` |

---

## Related

- [Readme.md](../Readme.md) — overview and full tool list
- [install.md](install.md) — setup, `setup.sh`, and dependencies
- [setup.sh](../setup.sh) — automated install script
