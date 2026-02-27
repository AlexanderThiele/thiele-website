---
title: "Gemini CLI Hooks: Automating the AI Alignment Loop"
description: "Discover how Gemini CLI hooks automate the AI alignment loop. Learn to use AfterAgent hooks for reliable, self-correcting AI code generation and orchestration."
date: 2026-02-27
slug: gemini-cli-hooks-automating-the-ai-alignment-loop
tags: ["Gemini CLI", "AI Orchestration", "Agentic Workflow"]
---

I’m convinced software engineering is entering a new chapter of AI-driven orchestration. As I [discussed recently](https://thiele.dev/blog/gemini-cli-ai-agentic-workflow-with-dart-jaspr/), our primary value is shifting from writing code to directing specialized AI agents. We are becoming orchestrators.

But as we delegate more to AI, a critical challenge emerges: the "trust gap." AI systems can generate hundreds of lines of code in seconds, but they are still prone to subtle logic flaws and syntax errors. How do we ensure quality without micromanaging the output?

Automating verification with **Gemini CLI hooks** is the answer. By using these hooks, we can complete the "alignment loop," turning AI from a fast typist into a reliable, self-correcting worker.

## What Are Gemini CLI Hooks?

In the Gemini CLI, hooks are automated scripts that run at specific points in an agent's workflow. Configured in a project’s [**.gemini/settings.json**](https://github.com/AlexanderThiele/thiele-website/blob/main/.gemini/settings.json) file, these hooks act as an invisible layer of quality assurance.

```json
{
  "hooks": {
    "AfterAgent": [
      {
        "matcher": "*",
        "hooks": [
          {
            "name": "dart-analyze",
            "type": "command",
            "command": ".gemini/hooks/dart_analyze.sh"
          },
          {
            "name": "jaspr-build",
            "type": "command",
            "command": ".gemini/hooks/jaspr_build.sh"
          }
        ]
      }
    ]
  }
}
```

> **Note (and a bit of a warning):** At the moment, `AfterAgent` only supports `*` for the `"matcher"`. The downside? It runs every single turn, even if you didn't touch a line of code. It’s like a personal trainer who makes you do 20 pushups every time you just *look* at a dumbbell. I really hope they fix this soon!

The most powerful is the **`AfterAgent` hook**. It runs after the agent completes its task but before the results are presented to you. It intercepts proposed changes and runs checks like formatting code, running linters or executing build processes.

## Prompting vs. Hooks: Why Mandatory Instructions Fail

Before hooks, many of us tried to enforce quality through prompting. We would add instructions like: "MANDATORY: Always run `dart analyze` after modifying code and fix any errors."

While this works sometimes, it’s fragile. Agents focused on a complex task can forget the command. Or they might run it, see a warning and ignore it. Relying on an LLM to police itself is a **leaky system**. You eventually have to step in, check the work and tell the agent it missed something.

Hooks fix this. Instead of asking the agent to remember a rule, the system enforces it. The agent doesn't choose to run the linter; the CLI runs it for them.

## Building an Automated Verification Loop with Hooks

Hooks communicate with the Gemini CLI using a simple JSON structure to issue a decision: **`allow`** or **`deny`**. This creates a powerful, automated verification loop.

Here is how this works in practice with two crucial checks in a Dart and Jaspr project:

### 1. The Code Quality Check

When an agent finishes writing code, an `AfterAgent` hook triggers the [**dart-analyze**](https://github.com/AlexanderThiele/thiele-website/blob/main/.gemini/hooks/dart_analyze.sh) shell script. It first runs `dart format` to keep the codebase clean and then runs `dart analyze`.

```bash
#!/bin/bash

# Format the code first (silently)
dart format lib > /dev/null 2>&1

# Run dart analyze and capture its output
OUTPUT=$(dart analyze lib 2>&1)

# Check if there are any issues by looking for "No issues found!"
if echo "$OUTPUT" | grep -q "No issues found!"; then
    echo '{"decision": "allow"}'
else
    CLEAN_OUTPUT=$(echo "$OUTPUT" | sed '1d')
    jq -n --arg output "$CLEAN_OUTPUT" '{decision: "deny", reason: ("The codebase has lint issues. Please fix ALL errors, warnings, and info messages (including deprecations):" + $output), systemMessage: "⚠️ Lint issues found!"}'
fi
```

If the analyzer finds no issues, the script returns **`{"decision": "allow"}`** and accepts the work. If there are errors, the script returns **`{"decision": "deny"}`** and feeds the error log back to the agent as a new prompt. The agent then fixes its own bugs before you ever see the result.

### 2. The Build Integrity Check

Linting doesn’t guarantee the application actually builds. A second hook can automatically run the [**jaspr-build**](https://github.com/AlexanderThiele/thiele-website/blob/main/.gemini/hooks/jaspr_build.sh) command, such as `jaspr build`.

```bash
#!/bin/bash

# Run jaspr build and capture output
OUTPUT=$(jaspr build 2>&1)

# Check if the build was successful (exit code 0)
if [ $? -eq 0 ]; then
    echo '{"decision": "allow"}'
else
    jq -n --arg output "$OUTPUT" '{decision: "deny", reason: ("The Jaspr build failed. Please fix the build issues:\n\n" + $output), systemMessage: "⚠️ Jaspr build failed!"}'
fi
```

If the build fails—perhaps due to a missing asset or a routing error—the hook **denies** the turn and feeds the failure log back to the agent.

This sequence—format, analyze, build—ensures the code is formatted, lint-free and functional before it ever reaches you.

## Completing the Alignment Loop

Gemini CLI hooks close the **alignment loop**.

In a standard workflow, the loop is open: the human provides intent, the AI generates code and the human must manually verify it. This manual check breaks flow and slows you down.

With **`AfterAgent` hooks**, the loop becomes autonomous. The AI generates code, the system verifies it against hard constraints and the AI self-corrects based on feedback. You are only brought back into the loop when the output is technically sound.

This shift lets us lean fully into the orchestrator role. We no longer spend time catching missed semicolons or broken imports. Instead, we can focus on what matters: architectural integrity, user experience and solving complex problems with speed, stability and precision.
