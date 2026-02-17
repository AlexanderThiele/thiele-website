# Image Manipulation with sips on macOS

## Type
Learning

## Date
2026-02-17

## Description
Used the native macOS `sips` (Scriptable Image Processing System) CLI tool to resize and convert images when specialized tools like ImageMagick are not installed.

## Context/Reasoning
During the favicon creation task, `magick` and `convert` were unavailable. `sips` is built into macOS and provides a reliable way to perform common image operations like resizing and format conversion directly from the shell.

## Actionable Item
When working on macOS environments without ImageMagick:
- Use `sips -z [height] [width] [input] --out [output]` for resizing.
- Use `sips -s format [format] [input] --out [output]` for format conversion.
- Note that `sips` might warn about file suffixes (e.g., when outputting a PNG as `.ico`), but browsers generally handle the resulting file correctly.
