# Decision: Refactor Hero Component for Customization

## Type
Decision

## Date
2026-02-15

## Description
Refactored the `Hero` component to accept dynamic `title` and `content` via attributes when used as a `CustomComponent` in Markdown.

## Context/Reasoning
The `Hero` component had hardcoded text intended for the home page. To reuse it on the "About" page with different text (as seen on the live site), it needed to support parameters. Using `jaspr_content`'s `CustomComponent` attributes allows for easy customization directly in Markdown.

## Actionable Item
Use `<Hero title="..." content="..." />` in Markdown files to customize the hero section. If attributes are omitted, it defaults to the home page's personal branding.
