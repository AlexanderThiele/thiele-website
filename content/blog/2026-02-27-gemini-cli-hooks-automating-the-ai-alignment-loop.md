---
title: "Gemini CLI Hooks: From Manual Checks to AfterTool & AfterAgent Autonomy"
description: "Discover how Gemini CLI hooks automate the AI alignment loop. Learn to use AfterAgent hooks for reliable, self-correcting AI code generation and orchestration."
date: 2026-02-27
updated: 2026-03-03
slug: gemini-cli-hooks-automating-the-ai-alignment-loop
tags: ["Gemini CLI", "AI Orchestration", "Agentic Workflow"]
---

I’m convinced software engineering is entering a new chapter of AI-driven orchestration. As I [discussed recently](https://thiele.dev/blog/gemini-cli-ai-agentic-workflow-with-dart-jaspr/), our primary value is shifting from writing code to directing specialized AI agents. We are becoming orchestrators.

But as we delegate more to AI, a critical challenge emerges: the "trust gap." AI systems can generate hundreds of lines of code in seconds, but they are still prone to subtle logic flaws and syntax errors. How do we ensure quality without micromanaging the output?

Automating verification with **Gemini CLI hooks** is the answer. By using these hooks, we can complete the "alignment loop," turning AI from a fast typist into a reliable, self-correcting worker.

## What Are Gemini CLI Hooks?

At their core, Gemini CLI hooks are automated interception points. They allow you to insert your own custom logic—like shell scripts or Python programs—directly into the AI agent's thought-and-action process. 

Think of them as strict guardrails or an automated peer reviewer. Instead of hoping the AI remembers your prompting instructions to format a file or run a test, a hook physically stops the agent, runs a deterministic check, and either allows the agent to continue or forces it to fix an error before moving forward.

These hooks act as an invisible layer of quality assurance. They are configured per-project in the [**.gemini/settings.json**](https://github.com/AlexanderThiele/thiele-website/blob/main/.gemini/settings.json) file, allowing you to tailor the rules exactly to your codebase's needs.

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

## Granular Control: AfterAgent vs. AfterTool

The Gemini CLI provides two primary types of hooks, each serving a different purpose in the verification loop. Understanding the distinction is key to building a robust workflow.

### AfterAgent: The Final Gatekeeper
The **`AfterAgent` hook** runs once at the very end of an agent's turn, after it has finished all its tool calls but before it hands the results back to you. 

It’s the "final gatekeeper." This is the perfect place for heavyweight checks that require a stable state, such as running a full test suite or executing a complete project build like `jaspr build`. It ensures that the *entire outcome* of the turn is valid.

### AfterTool: Atomic Verification
The **`AfterTool` hook** is more granular. It runs immediately after a specific tool is executed. By using a **matcher**, you can target specific operations. For example, using `write_.*` ensures the hook triggers every time the agent uses `write_file` or `replace`.

This is "atomic verification." It allows you to catch issues at the moment they are created. If an agent writes a single malformed file, the `AfterTool` hook can stop them immediately, rather than waiting for the end of the turn.

## Building an Automated Verification Loop

Hooks communicate with the Gemini CLI using a simple JSON structure to issue a decision: **`allow`** or **`deny`**. This creates a powerful, automated self-correction cycle.

### 1. Atomic Quality: The AfterTool "Write" Hook

One of the most effective uses of `AfterTool` is to enforce standards the moment a file is saved. In my [**settings.json**](https://github.com/AlexanderThiele/thiele-website/blob/main/.gemini/settings.json), I’ve configured an `AfterTool` hook that triggers on any write operation:

```json
{
  "hooks": {
    "AfterTool": [
      {
        "matcher": "write_.*",
        "hooks": [
          {
            "name": "after-write-analyze",
            "type": "command",
            "command": ".gemini/hooks/after_write.sh"
          }
        ]
      }
    ]
  }
}
```

The [**after_write.sh**](https://github.com/AlexanderThiele/thiele-website/blob/main/.gemini/hooks/after_write.sh) script is smart. It doesn't just run blindly; it inspects the tool input to see which file was touched. If it's a `.dart` file, it automatically formats it and then runs `dart analyze` on the library.

```bash
#!/bin/bash

# Read tool input via stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Auto-format Dart files immediately
if [[ -n "$FILE_PATH" && "$FILE_PATH" == *.dart ]]; then
    dart format "$FILE_PATH" > /dev/null 2>&1
fi

# Run analysis and deny if issues are found
OUTPUT=$(dart analyze lib 2>&1)

if echo "$OUTPUT" | grep -q "No issues found!"; then
    echo '{"decision": "allow"}'
else
    CLEAN_OUTPUT=$(echo "$OUTPUT" | sed '1d')
    jq -n --arg output "$CLEAN_OUTPUT" '{decision: "deny", reason: ("Lint issues found: " + $output), systemMessage: "⚠️ Lint issues found!"}'
fi
```

By intercepting write operations, we ensure that no "dirty" code ever stays in the workspace for more than a few seconds. The agent is forced to fix the file before moving on to its next task.

### 2. The Final Build: The AfterAgent Check

While `AfterTool` keeps individual files clean, the **`AfterAgent` hook** handles the big picture. Even if every file passes linting, they might not work together. A missing export or a broken route only shows up during a full build.

I use `AfterAgent` to run [**jaspr-build**](https://github.com/AlexanderThiele/thiele-website/blob/main/.gemini/hooks/jaspr_build.sh).

```bash
#!/bin/bash

# Run the full Jaspr build process
OUTPUT=$(jaspr build 2>&1)

if [ $? -eq 0 ]; then
    echo '{"decision": "allow"}'
else
    jq -n --arg output "$OUTPUT" '{decision: "deny", reason: ("Build failed:\n" + $output), systemMessage: "⚠️ Build failed!"}'
fi
```

If the build fails, the hook **denies** the entire turn. The agent receives the build log, realizes the integration failed, and tries a different approach.

## Completing the Alignment Loop

Gemini CLI hooks close the **alignment loop**.

In a standard workflow, the loop is open: the human provides intent, the AI generates code, and the human must manually verify it. This manual check breaks flow and slows you down.

With **hooks in place**, the loop becomes autonomous. The AI generates code, the system verifies it against hard constraints, and the AI self-corrects based on feedback. You are only brought back into the loop when the output is technically sound.

This shift lets us lean fully into the orchestrator role. We no longer spend time catching missed semicolons or broken imports. Instead, we can focus on what matters: architectural integrity, user experience, and solving complex problems with speed, stability, and precision.

Ready to dive deeper? Check out my follow-up post on [Mastering the AfterTool Hook](https://thiele.dev/blog/gemini-cli-aftertool-hook-ai-alignment/) to see how to implement atomic verification and path injection.