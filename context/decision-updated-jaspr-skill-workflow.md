# Decision: Updated Jaspr Skill Workflow

## Type
Decision

## Date
2026-02-14

## Description
Updated the `dart-jaspr-dev` skill to enforce a mandatory verification workflow.

## Context/Reasoning
To ensure code quality and application stability, the user requested that I always run `dart analyze` (fixing all errors) followed by `jaspr build` (checking for successful build) after making changes.

## Actionable Item
Always follow the "Mandatory Verification Workflow" defined in the `dart-jaspr-dev` skill:
1. `dart analyze` and fix errors.
2. `jaspr build` and verify successful completion.
