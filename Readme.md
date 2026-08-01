# Ty's Tools (Swiss Army CLI)

![status](https://img.shields.io/badge/status-active_development-2ea043?style=for-the-badge)
![utility](https://img.shields.io/badge/utility-command_line-2563EB?style=for-the-badge)

A polished, user-friendly **command-line utility collection** designed to house all my frequently used tools in one place. I am not the biggest fan of intrusive online converters with ads, paywalls, and network issues. Everything here runs cleanly and quickly right from the terminal.

---

## Why this Repository?

**Consolidated Workflow.** Instead of relying on random websites to perform basic tasks like compressing an image, merging files, or converting a video to a GIF, I built this repository to act as a personal "Swiss Army Knife". 

**Polished Experience.** The terminal doesn't have to be boring. These tools are built with user experience in mind, providing clear progress feedback and a clean interface.

---

## Table of Contents

- [Why this Repository?](#why-this-repository)
- [Available & Planned Tools](#available--planned-tools)
- [Installation & Setup](#installation--setup)
- [Author](#author)

---

## Available & Planned Tools

This project is currently expanding into a comprehensive suite of offline tools divided by category.

### Video & Audio (`tools/video/` & `tools/audio/`)
- [x] **video-to-gif**: Converts a local video file (e.g., .mp4) or a remote video URL into a high-quality GIF. Automatically handles uploading the GIF to provide a URL for easy sharing. (`bin/to_gif`)
- [ ] **extract-audio**: Pull MP3/WAV tracks from video files.
- [ ] **compress-video**: Optimize video files for web sharing.
- [ ] **trim-media**: Quickly crop or trim media duration without re-encoding.

### PDF Toolkit (`tools/pdf/`)
A complete offline alternative to tools like iLovePDF.
- **Manipulation:**
  - [ ] `merge-pdf`: Combine PDFs in the order you want.
  - [ ] `split-pdf`: Separate one page or a whole set for easy conversion into independent PDF files.
  - [ ] `organize-pdf`: Sort, delete, or add pages to your document.
  - [ ] `rotate-pdf`: Rotate your PDFs the way you need them.
  - [ ] `crop-pdf`: Crop margins or specific areas of PDF documents.
- **Conversion (From PDF):**
  - [ ] `pdf-to-word`: Convert PDF into DOC/DOCX.
  - [ ] `pdf-to-excel`: Pull data straight from PDFs into Excel.
  - [ ] `pdf-to-ppt`: Turn PDFs into PPTX slideshows.
  - [ ] `pdf-to-jpg`: Convert each PDF page into a JPG.
  - [ ] `pdf-to-md`: Turn PDFs into Markdown files for notes and LLMs.
- **Conversion (To PDF):**
  - [ ] `word-to-pdf`: Convert DOC/DOCX to PDF.
  - [ ] `excel-to-pdf`: Convert EXCEL to PDF.
  - [ ] `ppt-to-pdf`: Convert PPTX to PDF.
  - [ ] `jpg-to-pdf`: Convert images to PDF.
  - [ ] `html-to-pdf`: Convert webpages to PDF via URL.
- **Optimization:**
  - [ ] `compress-pdf`: Reduce file size while optimizing quality.
  - [ ] `pdf-to-pdfa`: Transform to ISO-standardized PDF/A for archiving.
- **Security & Metadata:**
  - [ ] `protect-pdf`: Encrypt PDF documents with passwords.
  - [ ] `unlock-pdf`: Remove PDF password security.
  - [ ] `sign-pdf`: Request or apply electronic signatures.
  - [ ] `watermark-pdf`: Stamp an image or text over your PDF.
  - [ ] `redact-pdf`: Permanently remove sensitive information.
- **Advanced / AI:**
  - [ ] `ocr-pdf`: Convert scanned PDF into searchable documents.
  - [ ] `summarize-pdf`: AI summarizer for articles and essays.
  - [ ] `translate-pdf`: Translate PDF files while keeping layout intact.
  - [ ] `repair-pdf`: Recover data from corrupt PDF files.
  - [ ] `pdf-forms`: Create and fill interactive forms.

### Image Toolkit (`tools/image/`)
- [ ] **compress-image**: Compress JPEG, PNG, WebP, GIF and SVG images locally (similar to TinyPNG but offline).
- [ ] **convert-image**: Easily convert between formats (e.g., AVIF to PNG, JPG to WebP).
- [ ] **strip-exif**: Remove metadata, EXIF, and GPS data for privacy before sharing.

### Developer Utilities (`tools/dev/`)
- [ ] **merge-files**: Combine multiple files into single archives.
- [ ] **format-json**: Pretty-print or minify JSON files.
- [ ] **csv-to-json**: Rapid conversion of data tables to JSON arrays.
- [ ] **base64-tool**: Encode and decode files or strings.
- [ ] **hash-gen**: Generate MD5, SHA-1, and SHA-256 checksums.

---

## Installation & Setup

To make these tools available anywhere on your system, you can add the `bin/` directory to your system's `$PATH`.

1. Clone the repository:
   ```bash
   git clone https://github.com/tmarhguy/to_gif.git ty-tools
   cd ty-tools
   ```
2. Add the `bin/` folder to your PATH (in your `.bashrc` or `.zshrc`):
   ```bash
   export PATH="$PATH:/path/to/ty-tools/bin"
   ```
3. Now you can invoke the wrappers from anywhere:
   ```bash
   to_gif https://example.com/video.mp4
   ```

---

## Author

**Tyrone Marhguy** — Computer Engineering '28, [University of Pennsylvania](https://www.upenn.edu/)

Questions or collabs — reach out.

| | |
|---|---|
| Email | [tmarhguy@gmail.com](mailto:tmarhguy@gmail.com) · [tmarhguy@engineering.upenn.edu](mailto:tmarhguy@engineering.upenn.edu) |
| Twitter | [@marhguy_tyrone](https://twitter.com/marhguy_tyrone) |
| Instagram | [@tmarhguy](https://instagram.com/tmarhguy) |
| Substack | [@tmarhguy](https://substack.com/@tmarhguy) |
| GitHub | [@tmarhguy](https://github.com/tmarhguy) |

![UPenn](https://img.shields.io/badge/UPenn-CE_2028-011F5B?style=for-the-badge)
![Software Engineering](https://img.shields.io/badge/Software_Engineering-tools-990000?style=for-the-badge)
![build in public](https://img.shields.io/badge/build_in_public-design_log-7C3AED?style=for-the-badge)
