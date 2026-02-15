# Refactored AppLayout to Separate File

## Type
Decision

## Date
2026-02-15

## Description
The main page layout logic was moved from `lib/main.server.dart` to a dedicated component file at `lib/components/app_layout.dart`. The class was renamed from `BlogLayout` to `AppLayout` to avoid naming conflicts with the `jaspr_content` library.

## Context/Reasoning
`lib/main.server.dart` was becoming too large. Moving the layout to its own file follows project conventions. Renaming to `AppLayout` avoids the need for `hide` clauses in imports, which is the preferred approach for resolving naming conflicts.

## Actionable Item
Use `AppLayout` for the main site-wide layout. New complex layouts should be created in `lib/components/` with unique names that don't conflict with framework components.
