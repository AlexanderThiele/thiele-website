# Decision: Dynamic Hero Images

## Type
Decision

## Date
2026-02-16

## Description
Each page now displays a specific hero image. Images were downloaded from `thiele.dev` and are stored in `web/images/hero/`. The `AppLayout` automatically maps the page path to the corresponding image file.

## Context/Reasoning
The user wanted to replicate the per-page hero images from the original website. Automating the mapping in `AppLayout` avoids manual frontmatter updates for every existing post while still allowing for custom overrides via the `image` frontmatter key.

## Actionable Item
- Images are named after the page slug (e.g., `blog/my-post` -> `web/images/hero/my-post.png`).
- To use a specific image for a new post, either name the image file to match the slug or specify `image: /path/to/image.png` in the frontmatter.
- All downloaded images currently use the `.png` extension for consistency in mapping, even if the source was a different format (browsers handle this correctly).
