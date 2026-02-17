---
name: context-learning-protocol
description: Automated protocol for capturing, organizing, and retrieving project context, preferences, and learnings. Use this skill at the end of significant tasks or when key user preferences or project-specific learnings are identified to ensure they are persistently recorded in /context/.
---

# Context Learning Protocol

## Overview
This skill enforces a disciplined approach to knowledge management within the project. It ensures that every significant user preference and technical learning is automatically captured in a structured format under the `/context/` directory. This allows the agent to "remember" and "learn" from past interactions, creating a self-improving development environment.

## Protocol Workflow

### 1. Identify Learnings
During or after a task, actively identify **TECHNICAL** aspects only:
- **Preferences:** User-stated likes/dislikes regarding style, syntax, or workflow (e.g., "User prefers 2-space indentation" or "Always use named parameters").
- **Learnings:** Solutions to tricky bugs, quirks of the codebase, performance optimizations, or **discoveries of non-obvious CLI tools and platform-specific utilities** (e.g., "Using `sips` for image processing on macOS" or "Hot reload fails when modifying `main.server.dart`").

**DO NOT** save minor UI/styling changes (e.g., color adjustments, padding, font sizes, or layout widths), project management updates, or purely content-related changes. However, **ALWAYS capture technical solutions, even if they seem like "one-off" fixes**, if they involve a specific tool or methodology that could be reused. Focus on technical context that impacts the development workflow or codebase architecture.

### 2. File Naming Convention
Save new context files in `context/` with descriptive, kebab-case names and a `.md` extension.
- Format: `context/[category]-[topic].md`
- Examples:
    - `context/preference-coding-style.md`
    - `context/learning-jaspr-routing.md`

### 3. File Structure
Each context file MUST follow this template:

```markdown
# [Title of Context]

## Type
[Preference | Learning]

## Date
[YYYY-MM-DD]

## Description
[Concise description of the context, or finding.]

## Context/Reasoning
[What happened? What is the user's rationale?]

## Actionable Item
[How should this affect future work? e.g., "Always use X for Y", "Do not suggest Z".]
```

### 4. Updating the Index
After creating or modifying a context file, YOU MUST update the master index at `context/GEMINI.md`.
- This file contains a table overview of all saved context.
- Format for `context/GEMINI.md`:

```markdown
# Project Context Index

| Date | Type | Topic | File |
|------|------|-------|------|
| 2026-02-14 | Learning | Blog Architecture | [learning-blog-arch.md](learning-blog-arch.md) |
| ... | ... | ... | ... |
```

## Automated Triggers
- **Post-Interaction Check:** Before finishing a turn or a task, ask yourself: "Did I learn something permanent?" If yes, execute this protocol.
- **Explicit Instruction:** If the user says "Remember this" or "Save this learning", execute this protocol immediately.

## Tool Usage
- Use `write_file` to create new context files.
- Use `read_file` to check `context/GEMINI.md` before updating it.
- Use `replace` or `write_file` to update `context/GEMINI.md`.
