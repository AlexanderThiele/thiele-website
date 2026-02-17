# New Favicon Implementation

## Type
Decision

## Date
2026-02-17

## Description
Created a new favicon and associated icons (apple-touch-icon, multiple PNG sizes) from a user-provided image (400x400 PNG).

## Context/Reasoning
The user provided a new personal image to be used as a favicon for the blog. 

## Actionable Item
The following files were created in `web/`:
- `favicon.ico` (32x32 PNG)
- `favicon-16x16.png`
- `favicon-32x32.png`
- `apple-touch-icon.png` (192x192 PNG)

The `AppLayout` component was updated to include explicit link tags in the `<head>` for these icons.
