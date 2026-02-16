# Decision: Global Hero Component

## Type
Decision

## Date
2026-02-16

## Description
The `Hero` component is now automatically included on every page via the `AppLayout`. It replaces the previous manual `content-header` and any manual `<Hero />` tags in Markdown files.

## Context/Reasoning
The user wanted a consistent Hero section (with image, title, and description) across all blog and content pages. Centralizing this in `AppLayout` ensures consistency and simplifies content creation by removing the need for manual component tags or top-level headings in Markdown.

## Actionable Item
- Do not manually add `<Hero />` to Markdown files unless a custom override is needed.
- New blog posts should include `title` and `description` in frontmatter.
- Avoid adding `# ` (h1) headings at the start of blog posts as they are now redundant with the Hero component.
