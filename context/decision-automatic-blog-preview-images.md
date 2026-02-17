# Automatic Blog Preview Images

## Type
Decision

## Date
2026-02-17

## Description
Implemented automatic resolution of preview images for blog entries in the `BlogGrid` component.

## Context/Reasoning
The user wanted the main blog overview to include preview images, similar to `https://thiele.dev/`. To avoid manually updating the frontmatter of every blog post, the `BlogGrid` component was updated to look for images in `/images/hero/` matching the post's slug or filename.

## Actionable Item
When adding new blog posts, ensure a corresponding hero image exists in `web/images/hero/[slug].png` to have it automatically appear as a preview in the blog grid.
