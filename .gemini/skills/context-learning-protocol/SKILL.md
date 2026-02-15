---
name: context-learning-protocol
description: Automated protocol for capturing, organizing, and retrieving project context, decisions, and learnings. Use this skill at the end of significant tasks or when key architectural decisions, user preferences, or project-specific learnings are identified to ensure they are persistently recorded in /context/.
---

# Context Learning Protocol

## Overview
This skill enforces a disciplined approach to knowledge management within the project. It ensures that every significant decision, user preference, and technical learning is automatically captured in a structured format under the `/context/` directory. This allows the agent to "remember" and "learn" from past interactions, creating a self-improving development environment.

## Protocol Workflow

### 1. Identify Learnings
During or after a task, actively identify **TECHNICAL** aspects only:
- **Decisions:** Architectural choices, library selections, or significant refactors (e.g., "Switched from Provider to Riverpod because...").
- **Preferences:** User-stated likes/dislikes regarding style, syntax, or workflow (e.g., "User prefers 2-space indentation" or "Always use named parameters").
- **Learnings:** Solutions to tricky bugs, quirks of the codebase, or performance optimizations (e.g., "Hot reload fails when modifying `main.server.dart`").

**DO NOT** save non-technical decisions, project management updates, or purely content-related changes unless they involve a technical implementation detail.

### 2. File Naming Convention
Save new context files in `context/` with descriptive, kebab-case names and a `.md` extension.
- Format: `context/[category]-[topic].md`
- Examples:
    - `context/decision-state-management.md`
    - `context/preference-coding-style.md`
    - `context/learning-jaspr-routing.md`

### 3. File Structure
Each context file MUST follow this template:

```markdown
# [Title of Context]

## Type
[Decision | Preference | Learning]

## Date
[YYYY-MM-DD]

## Description
[Concise description of the context, decision, or finding.]

## Context/Reasoning
[Why was this decided? What happened? What is the user's rationale?]

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
| 2026-02-14 | Decision | Blog Architecture | [decision-blog-arch.md](decision-blog-arch.md) |
| ... | ... | ... | ... |
```

## Automated Triggers
- **Post-Interaction Check:** Before finishing a turn or a task, ask yourself: "Did I learn something permanent?" If yes, execute this protocol.
- **Explicit Instruction:** If the user says "Remember this" or "Save this decision", execute this protocol immediately.

## Tool Usage
- Use `write_file` to create new context files.
- Use `read_file` to check `context/GEMINI.md` before updating it.
- Use `replace` or `write_file` to update `context/GEMINI.md`.
