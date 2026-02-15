# Add Push Command for Automated Git Workflow

## Type
Decision

## Date
2026-02-15

## Description
Added a new Gemini CLI command `push` in `.gemini/commands/push.toml`.

## Context/Reasoning
The `push` command automates the standard git workflow: checking staged changes, generating a conventional commit message, committing, and pushing to origin. This improves efficiency and ensures consistent commit message formatting.

## Actionable Item
Users can now use the `push` command (if supported by the CLI environment) to quickly commit and push changes. The prompt used for this command is stored in `.gemini/commands/push.toml`.
