# BMSCE Academic Project Report Template

A modular, standardized LaTeX template for academic project reports at B.M.S. College of Engineering (BMSCE). This template automates institutional formatting requirements while providing a clean, modern structure for technical documentation.

## Features
- **Engine Support**: Full compatibility with `pdflatex` and `lualatex`.
- **Institutional Compliance**: Automated Title Page, Certificate, and Declaration pages following BMSCE standards.
- **Modular Structure**: Chapters are separated into individual files for easier collaboration and management.
- **Bibliography**: Modern `biblatex` with `biber` (IEEE style).
- **Automated Metadata**: Manage student names, USNs, and guides from a single location in `main.tex`.

---

## Installation & Setup

### 1. Overleaf (Recommended)
1. Create a **New Project** > **Upload Project**.
2. Upload the `.zip` file of this repository.
3. In Overleaf Settings (Left Panel):
   - **Compiler**: Select `LuaLaTeX` (for best font support) or `PDFLaTeX`.
   - **TeX Live Version**: `2023` or newer.
4. Hit **Recompile**.

### 2. Windows
1. Install **MiKTeX**: [miktex.org](https://miktex.org/download)
2. Install **Perl** (required for Biber): [Strawberry Perl](https://strawberryperl.com/)
3. Open the project in **TeXstudio** or **VS Code** (with LaTeX Workshop extension).
4. Compilation sequence: `LuaLaTeX` -> `Biber` -> `LuaLaTeX` (twice).

### 3. Ubuntu / Debian
Install the full TeX Live distribution:
```bash
sudo apt update
sudo apt install texlive-full
```
Compile using the command line:
```bash
lualatex main
biber main
lualatex main
```

### 4. macOS
1. Install **MacTeX**: [tug.org/mactex](https://tug.org/mactex/)
2. (Optional) Use **TeXShop** (included) or **VS Code**.
3. Compile using `LuaLaTeX` and `Biber`.

### 5. Arch Linux
Install the required packages:
```bash
sudo pacman -S texlive-basic texlive-latexextra texlive-fontsrecommended texlive-fontsextra texlive-bibtexextra texlive-luatex biber
```
If using LuaLaTeX and fonts are not found, run:
```bash
luaotfload-tool --update
```

---

## Usage

### Customizing Metadata
Open `main.tex` and update the following commands:
```latex
\projecttitle{Your Project Title}
\addstudent{Student Name}{USN}
\guidename{Dr. Name}
\branch{Computer Science and Engineering}
```

### Managing Content
- Add your chapters in the `chapters/` directory.
- Update `references.bib` with your citations.
- To include a new chapter, add `\include{chapters/your_file}` in `main.tex`.

## Troubleshooting
- **Missing luaotfload**: If you get a "luaotfload not found" error on Linux/Arch, ensure `texlive-luatex` is installed and run `luaotfload-tool --update`.
- **Duplicate Page Identifiers**: The template uses `Alph` and `roman` numbering for front matter to prevent `hyperref` conflicts with Chapter 1. Do not change the `\pagenumbering` manually unless necessary.

## License
3-clause BSD modified to include documentation. Refer LICENSE for more information
