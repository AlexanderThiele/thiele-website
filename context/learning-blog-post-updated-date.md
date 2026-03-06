# Blog Post Updated Date Handling

## Type
Learning

## Date
2026-03-06

## Description
Implementation of an "updated" field in blog post frontmatter and its rendering in the `BlogGrid` and `AppLayout` components.

## Context/Reasoning
The user wanted to show an "Updated at" date next to the "Published date" only if the post was actually updated. This required:
1. Adding an `updated` field to Markdown frontmatter.
2. Manually parsing this field in `BlogGrid` (since it reads files directly).
3. Accessing it via `page.data.page` in `AppLayout` (since it uses the Jaspr content data).
4. Formatting both dates (Published and Updated) consistently.

## Actionable Item
When adding features that involve blog post metadata:
- Update `_PostData` and `_parsePost` in `lib/components/blog_grid.dart` for the grid view.
- Update `AppLayout` in `lib/components/app_layout.dart` for the detail view.
- Ensure that the field is optional and only rendered if it exists.
- Use `Component.text()` instead of the deprecated `text()` function in Jaspr components.
