---
name: creating-images
description: Expert guidance for generating images (PNG, JPG) using built-in macOS tools like qlmanage and sips. Specialized in creating high-quality, modern hero images (1200x630px) with fancy gradients and clean typography.
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

### 2. "Fancy Modern" Hero Images

Use this workflow to create high-fidelity hero images with soft gradients, rounded "inner glow" borders, and bold typography.

**Gradient Palette (Pick 2 randomly for each image):**
- **Tiffany Blue:** `#90f1ef`
- **Pink:** `#ffd6e0`
- **Yellow:** `#ffef9f`
- **Light Green:** `#c1fba4`
- **Mint:** `#7bf1a8`
- **Text:** `#1e293b` (Slate 800)
- **Accent:** `#0891b2` (Cyan 600)

**SVG Template:**
```xml
<svg width="1200" height="1200" viewBox="0 0 1200 1200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg-grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="{RANDOM_COLOR_1}" />
      <stop offset="100%" stop-color="{RANDOM_COLOR_2}" />
    </linearGradient>
  </defs>
  
  <rect width="1200" height="1200" fill="#ffffff" />

  <g transform="translate(0, 285)">
    <!-- Main Content Background -->
    <rect width="1200" height="630" fill="url(#bg-grad)" />
    
    <!-- Inner Rounded Border (Glow Effect) -->
    <rect x="30" y="30" width="1140" height="570" rx="40" ry="40" fill="none" stroke="#ffffff" stroke-width="6" opacity="0.5" />
    
    <!-- Left Icon (Scale 6x) -->
    <g transform="translate(100, 100) scale(6)" fill="#8b5cf6">
      <!-- Inject <path> from asset here -->
    </g>

    <!-- Content Group -->
    <g transform="translate(100, 440)">
      <text font-family="Helvetica, Arial, sans-serif" font-size="80" font-weight="900" fill="#1e293b" style="text-transform: uppercase; letter-spacing: -2px;">
        {TITLE}
      </text>
      <text y="75" font-family="Helvetica, Arial, sans-serif" font-size="36" font-weight="600" fill="#475569">
        {SUBTITLE}
      </text>
    </g>
  </g>
</svg>
```

### 3. Image Manipulation with `sips`

`sips` (Scriptable Image Processing System) is a powerful built-in macOS tool.

- **Get Dimensions**: `sips -g pixelWidth -g pixelHeight [file]`
- **Resizing**: `sips -z [height] [width] [file]` (Maintains aspect ratio if only one is specified?) -> Actually `sips -Z [max_dimension]` is better for maintaining ratio.
- **Cropping**: `sips -c [height] [width] [file] --out [output]` (Crops from the center).
- **Format Conversion**: `sips -s format [png|jpeg|tiff|...] [file] --out [output]`

## Tips

- **Font Support**: When creating SVGs for `qlmanage`, use generic system font families (`sans-serif`, `monospace`, `serif`) or specific macOS fonts (`Helvetica`, `Menlo`, `Monaco`) to ensure predictable rendering.
- **SVG Paths**: Simple SVG paths and groups work best. Avoid complex filters or external resource links within the SVG.
- **Verification**: Always verify the final output dimensions using `sips -g`.
