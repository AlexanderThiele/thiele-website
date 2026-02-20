---
name: creating-images
description: Expert guidance for generating images (PNG, JPG) using built-in macOS tools like qlmanage and sips. Use when Pillow, ImageMagick, or other third-party image libraries are unavailable.
---

# Creating Images

## Overview

This skill provides a fallback workflow for generating and manipulating images when common libraries (Pillow, ImageMagick) are missing. It leverages macOS-specific command-line utilities.

## Assets

The `.gemini/skills/creating-images/assets/` directory contains various SVG logos:
- **Flutter Logo:** `flutter_logo.svg`
- **Dart Logo:** `dart_logo.svg`
- **Jaspr Logo:** `jaspr_logo.svg`
- **Gemini CLI Logo:** `gemini_logo.svg`

When generating SVGs that require these logos, read their files and inject their `<path>` or `<g>` contents into your target SVG template. Use `<g transform="...">` tags to scale and position them correctly.

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
5. **Advanced Template Example (Multi-Logo Hero):**
   When using external logos, you can use gradients and `transform="... scale(...)"` groups to position and size them appropriately within the target content area.
   ```xml
   <svg width="1200" height="1200" viewBox="0 0 1200 1200" xmlns="http://www.w3.org/2000/svg">
     <defs>
       <!-- Optional gradients for logos -->
       <linearGradient id="dart-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
         <stop offset="0%" stop-color="#01599B"/><stop offset="100%" stop-color="#0175C2"/>
       </linearGradient>
     </defs>
     <rect width="1200" height="1200" fill="#ffffff" />
     <g transform="translate(0, 285)">
       <rect width="1200" height="630" fill="#0f111a" />
       
       <!-- Left Logo (Scale 6x) -->
       <g transform="translate(338, 160) scale(6)">
         <!-- Injected <path> data here -->
       </g>

       <!-- Center Logo (Scale 0.6x) -->
       <g transform="translate(537, 140) scale(0.6)">
         <!-- Injected <path> data here -->
       </g>

       <!-- Right Logo (Scale 6x) -->
       <g transform="translate(718, 160) scale(6)">
          <!-- Injected <path> data here -->
       </g>
       
       <text x="600" y="440" text-anchor="middle" font-family="Helvetica, sans-serif" font-size="64" font-weight="bold" fill="#ffffff">Title</text>
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
