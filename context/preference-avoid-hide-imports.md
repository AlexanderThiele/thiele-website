# Prefer Renaming over Hiding Conflicts

## Type
Preference

## Date
2026-02-15

## Description
When a local class or component name conflicts with an imported library (e.g., `jaspr_content`), prefer renaming the local entity to a more specific name (e.g., `AppLayout`) instead of using the `hide` clause in imports.

## Context/Reasoning
Using `hide` is considered a suboptimal practice as it can lead to confusion and makes the codebase harder to maintain. Explicit naming provides better clarity and avoids future name collisions if more entities are added to the library.

## Actionable Item
Always check for naming conflicts with libraries. If one exists, rename the local component/class to something unique and descriptive.
