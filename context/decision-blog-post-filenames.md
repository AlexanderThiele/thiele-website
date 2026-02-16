# Decision: Blog Post Filename Format and URL Preservation

## Type
Decision

## Date
2026-02-16

## Description
Renamed blog post Markdown files to follow the `YYYY-MM-dd-NAME.md` format while preserving their original URL paths (`/blog/NAME`).

## Context/Reasoning
The user requested a specific filename format that includes the publication date. However, `jaspr_content` by default uses the filename as the URL slug. To prevent breaking existing links and SEO, we decoupled the filename from the URL by adding a `slug` field to the frontmatter and implementing custom routing logic.

## Actionable Item
- New blog posts should be named `YYYY-MM-dd-slug.md`.
- Always include `slug: original-slug` in the frontmatter to maintain a stable URL.
- The `routerBuilder` in `lib/main.server.dart` handles the mapping from the date-prefixed filename to the stable slug URL.
- `BlogGrid` and `AppLayout` have been updated to prioritize the `slug` frontmatter field for link generation and hero image resolution.
