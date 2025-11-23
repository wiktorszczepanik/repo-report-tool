# README Generator for CTF Write-ups

This repo provides a script that automatically generates clean, structured README file based on existing CTF write-ups.
It recursively scans a directory containing challenge solutions, extracts descriptive information, and collects various statistics such as categories, difficulty levels, and platforms. 

## Usage

The script is packaged as a single portable app.lua file located in the app/ directory. You can run it by providing the path to the repository and path to the report file with a *.md* extension. 

```Bash
$ lua app.lua [path to repo] [path to report file]
```

## Report contents

The generated README includes a static summary of all completed CTF challenges and automatically counted totals across categories, difficulty levels, and platforms. The collected values and statistics are presented in formatted Markdown tables.

Among the generated elements are:

- Total number of completed challenges
- Breakdown by category (e.g., Web, Crypto, Forensics)
- Breakdown by difficulty (easy / medium / hard)
- Breakdown by platform (e.g., PicoCTF, TryHackMe, Other)

## Tags

All data is gathered directly from tags embedded in the write-up files, ensuring consistency, automation, and minimal manual input. Currently supported tags include category, platform and difficulty.