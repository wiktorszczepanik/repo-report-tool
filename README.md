# README Generator for CTF Write-ups

This repo provides a script that automatically generates clean, structured README file based on existing CTF write-ups.
It recursively scans a directory containing challenge solutions, extracts descriptive information, and compiles various statistics such as categories, difficulty levels, and platforms into readable Markdown tables. 

## Report contents

The generated README includes a static summary of all completed CTF challenges and automatically counted totals across categories, difficulty levels, and platforms. The collected values and statistics are presented in formatted Markdown tables.

Among the generated elements are:

- Total number of completed challenges
- Breakdown by category (e.g., Web, Crypto, Forensics)
- Breakdown by difficulty (easy / medium / hard)
- Breakdown by platform (e.g., PicoCTF, TryHackMe, Other)

## Tags

All data is gathered directly from tags embedded in the write-up files, ensuring consistency, automation, and minimal manual input. Currently supported tags include category, platform and difficulty.

## Why
I wanted to write something more than `print("Hello World!")` in Lua.