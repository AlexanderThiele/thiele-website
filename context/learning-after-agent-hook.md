# AfterAgent Hook for Dart Analysis

## Type
Learning

## Date
2026-02-25

## Description
Implemented an `AfterAgent` hook that runs `dart analyze` and forces a retry if any errors, warnings, or info messages are found. This ensures the agent always delivers a clean codebase.

## Context/Reasoning
The user wanted to automate the process of fixing lint issues. By using an `AfterAgent` hook, the CLI can automatically reject a response that introduces or leaves lint issues, providing the analysis output back to the agent for correction.

## Actionable Item
The hook is configured in `.gemini/settings.json` and runs `.gemini/hooks/dart_analyze.sh`. Future agents will be automatically prompted to fix any `dart analyze` issues if they occur.
