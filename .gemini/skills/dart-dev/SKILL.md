---
name: dart-dev
description: Expert guidance for Dart development. Use for core language features, package management (pubspec.yaml), linting (analysis_options.yaml), and general software engineering practices in Dart.
---

# Dart Development

## Core Principles
- **Strong Typing:** Always define types for parameters, return values, and variables.
- **Async/Await:** Use for non-blocking operations.
- **Package Management:** Manage dependencies via `pubspec.yaml`.

## Best Practices
- **Linting:** Strictly follow `analysis_options.yaml`.
- **Analysis:** Frequently run `dart analyze` to catch issues early.
- **Formatting:** Use `dart format` to maintain consistent style.

## Workflows
- **Adding Dependencies:** Add to `pubspec.yaml` and run `dart pub get`.
- **Fixing Issues:** Resolve all issues reported by `dart analyze` before finalizing work.

## Mandatory Verification Workflow
AFTER making code changes and BEFORE considering a task complete, you MUST:
1. **Analyze:** Run `dart analyze` and fix ALL reported errors and warnings.
