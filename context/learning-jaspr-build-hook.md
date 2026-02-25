# Jaspr Build Hook

## Type
Learning

## Date
2026-02-25

## Description
A new hook was added to the `AfterAgent` sequence in `.gemini/settings.json` that runs `jaspr build` after every write operation.

## Context/Reasoning
To ensure that changes made to the codebase do not break the actual build of the static site, a `jaspr build` check is now performed automatically. This complements the `dart-analyze` lint check.

## Actionable Item
Keep the `jaspr build` hook active to maintain build integrity. If the build becomes too slow for frequent writes, consider optimizing the build process or adjusting the `matcher` in `settings.json`.
