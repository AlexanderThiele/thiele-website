---
name: creating-images
description: Expert guidance for generating images (PNG, JPG) using built-in macOS tools like qlmanage and sips. Use when Pillow, ImageMagick, or other third-party image libraries are unavailable.
---

# Creating Images

## Overview

This skill provides a fallback workflow for generating and manipulating images when common libraries (Pillow, ImageMagick) are missing. It leverages macOS-specific command-line utilities.

## Assets

- **Flutter Logo:** A Flutter logo SVG is available at `.gemini/skills/creating-images/assets/flutter_logo.svg`. When generating SVGs that require a Flutter logo, read this file and inject its `<path>` and `<g>` contents (or the entire `<svg>` as an inner `<svg>` element) into your target SVG template to ensure correct rendering.

## Workflows

### 1. Generating PNG from SVG (macOS)

`qlmanage` (QuickLook) can render SVGs into PNG thumbnails. However, it has a "square scaling" quirk: it always scales the content to fit its square thumbnail area, which can distort non-square SVGs.

**The "Square Canvas" Pattern:**
1. **Create a Square SVG**: Always use a 1:1 aspect ratio for the SVG canvas (e.g., 1200x1200px).
2. **Center the Content**: Place your target content area (e.g., 1200x630px) in the vertical center.
   - For a 1200x1200px canvas and 1200x630px content, the vertical offset is `(1200 - 630) / 2 = 285px`.
   - Wrap your content in a `<g transform="translate(0, 285)">` tag.
3. **SVG Template Example**:
   ```xml
   <svg width="1200" height="1200" viewBox="0 0 1200 1200" xmlns="http://www.w3.org/2000/svg">
     <rect width="1200" height="1200" fill="white" />
     <g transform="translate(0, 285)">
       <!-- Your 1200x630 content here -->
       <text x="600" y="315" text-anchor="middle" font-family="sans-serif" font-size="80">Title</text>
     </g>
   </svg>
   ```
4. **Generate Thumbnail**:
   ```bash
   qlmanage -t -s [width] -o . [file].svg
   ```
   This produces `[file].svg.png`.
4. **Crop to Final Aspect Ratio**: Use `sips` to perform a centered crop to your target dimensions.
   ```bash
   sips -c [target_height] [target_width] [file].svg.png --out [final_name].png
   ```

### 2. Image Manipulation with `sips`

`sips` (Scriptable Image Processing System) is a powerful built-in macOS tool.

- **Get Dimensions**: `sips -g pixelWidth -g pixelHeight [file]`
- **Resizing**: `sips -z [height] [width] [file]` (Maintains aspect ratio if only one is specified?) -> Actually `sips -Z [max_dimension]` is better for maintaining ratio.
- **Cropping**: `sips -c [height] [width] [file] --out [output]` (Crops from the center).
- **Format Conversion**: `sips -s format [png|jpeg|tiff|...] [file] --out [output]`

## Tips

- **Font Support**: When creating SVGs for `qlmanage`, use generic system font families (`sans-serif`, `monospace`, `serif`) or specific macOS fonts (`Helvetica`, `Menlo`, `Monaco`) to ensure predictable rendering.
- **SVG Paths**: Simple SVG paths and groups work best. Avoid complex filters or external resource links within the SVG.
- **Verification**: Always verify the final output dimensions using `sips -g`.
