# YAML Frontmatter Parsing Issues

## Type
Learning

## Date
2026-02-17

## Description
Multiple blog posts had invalid YAML in their frontmatter, causing `jaspr build` to fail with `FrontMatterException`.

## Context/Reasoning
The issues identified were:
1. **Unclosed Quotes:** A description started with `"` but never ended with one, causing the rest of the frontmatter to be parsed as part of the string.
2. **Special Characters:** The `&` character in a description was not quoted. `&` is a reserved character in YAML for anchors.
3. **Extra Delimiters:** A horizontal rule `---` inside the Markdown content was being picked up as a frontmatter delimiter by the parser, causing it to see more than two parts.
4. **Dates:** Some dates were not quoted, which can sometimes cause issues depending on the YAML parser version (though not confirmed as the primary cause here, quoting is safer).

## Actionable Item
- Always quote strings in YAML frontmatter that contain special characters like `:`, `&`, or emojis.
- Ensure all quotes are closed.
- Use `***` or `___` for horizontal rules in Markdown to avoid confusion with `---` frontmatter delimiters.
- Quote dates (`date: "YYYY-MM-DD"`) to ensure they are consistently treated as strings.
