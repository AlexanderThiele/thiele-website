# Learning: Dart Analyze Hook with Auto-Formatting

## Type
Learning

## Date
2026-02-25

## Description
Updated the `.gemini/hooks/dart_analyze.sh` hook to run `dart format lib` before `dart analyze lib`.

## Context/Reasoning
The user wants to ensure that all code is properly formatted before it is analyzed for lint issues. This reduces the number of "formatting" related lint errors (if any) and ensures a consistent codebase.

## Actionable Item
The `dart_analyze.sh` hook now automatically formats the `lib/` directory. Future changes that trigger this hook will have their formatting corrected automatically.
