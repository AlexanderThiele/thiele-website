# Learning: Generating Hero Images on macOS with qlmanage and sips

## Type
Learning

## Date
2026-02-19

## Description
When traditional image generation tools like Pillow or ImageMagick are unavailable, macOS's `qlmanage` and `sips` can be used to generate PNG images from SVGs.

## Context/Reasoning
The agent needed to create a hero image for a blog post but lacked Python's Pillow or ImageMagick. Since the environment was macOS (`darwin`), it leveraged `qlmanage` (QuickLook) to render a manually constructed SVG into a PNG thumbnail, and then used `sips` to crop the image to the desired dimensions.

## Actionable Item
To generate an image on macOS without extra dependencies:
1. Create a **square** SVG file (e.g., 1200x1200px) and place your content area (e.g., 1200x630px) in the vertical center. This is crucial because `qlmanage` will scale non-square SVGs to fit the square thumbnail, distorting them if they aren't already square.
2. Run `qlmanage -t -s [width] -o . [file].svg` to generate a `[file].svg.png`.
3. Use `sips -c [height] [width] [file].svg.png --out final.png` to crop the square thumbnail to the correct aspect ratio from the center.
