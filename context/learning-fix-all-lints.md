# Fix All Lint Issues

## Type
Learning

## Date
2026-02-15

## Description
The agent failed to address warnings and info messages (deprecations) reported by `dart analyze`. The `dart-dev` skill was updated to explicitly mandate fixing ALL issues, including info messages and deprecations.

## Context/Reasoning
The user pointed out that `dart analyze` was reporting warnings and info messages that were not being fixed. While the skill already mentioned fixing "errors and warnings", it wasn't explicit about "info" messages which often include important deprecations.

## Actionable Item
Always run `dart analyze` after any code change and ensure that the output is "No issues found!". This includes resolving all errors, warnings, and info/deprecation messages.
