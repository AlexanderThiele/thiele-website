# Custom Blog Layout Implementation

## Type
Decision

## Date
2026-02-15

## Description
Implemented a custom `BlogLayout` extending `PageLayout` to replace the default `DocsLayout`. This provides granular control over the rendering of the `content-header` (title and description).

## Context/Reasoning
The default `DocsLayout` automatically renders the page title and description from Markdown frontmatter. This caused duplicate titles when using custom components like the `Hero` section. A custom layout was necessary to allow hiding these elements while still preserving them in the frontmatter for SEO purposes.

## Actionable Item
- Use `BlogLayout` in `lib/main.server.dart`.
- To hide the automatic title/description on any page, add `hideTitle: true` to the Markdown frontmatter.
- Access frontmatter data in the layout via `page.data.page['key']`.
- Use `main_()` DOM tag to avoid naming collisions.
