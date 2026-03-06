---
title: "Gemini CLI: Mastering the AfterTool Hook"
description: "Discover how to automate AI verification using the Gemini CLI AfterTool hook. Learn to enforce code formatting, linting, and build steps instantly during AI tool execution."
date: 2026-03-06
slug: gemini-cli-aftertool-hook-ai-alignment
tags: ["Gemini CLI", "Hooks", "AI Orchestration", "Agentic Workflow"]
---

The Gemini CLI uses hooks to automate verification and close the AI alignment loop. The [AfterAgent hook](https://thiele.dev/blog/gemini-cli-hooks-automating-the-ai-alignment-loop/) acts as the final gatekeeper after an AI finishes its turn. You might use it for full project builds or test suites. In contrast, the AfterTool hook operates at a much more granular level.

**TL;DR:** While the `AfterAgent` hook verifies the final state of an AI agent's turn, the `AfterTool` hook triggers immediately after individual tool calls (like writing a file). This allows you to instantly format code, run specific linters, or trigger the build runner for modified files, keeping the feedback loop incredibly tight and autonomous.

## What is the AfterTool Hook?

The `AfterTool` hook runs immediately after the AI agent executes a tool. You can target precise operations by configuring a matcher in the `.gemini/settings.json` file. 

For instance, a matcher like `"write_.*"` triggers the hook every time the agent uses `write_file` or `replace`. This enables atomic verification. The system catches issues exactly when they are created. If an agent writes a malformed file, the `AfterTool` hook intercepts the process. It stops the agent immediately, rather than waiting for the turn to finish.

## Why the AfterTool Hook is Important

The `AfterTool` hook enforces standards the moment a file is saved. This provides an extremely tight feedback loop for the AI agent.

Running a full suite of checks after every agent action is too slow in large codebases. The `AfterTool` hook solves this with targeted analysis. The hook triggers immediately after a file modification. This means you can scope checks specifically to that single file.

- **Formatting:** You can instantly check if the code meets your project's formatting guidelines.
- **Linting:** You can analyze the modified file for new warnings or errors.
- **Immediate Correction:** If the hook finds issues, it can deny the tool execution. This forces the AI to fix the problem before moving on.

Analyzing only the modified file keeps the verification process fast. It maintains an efficient AI workflow and a clean workspace.

## Path Injection and Auto-Formatting

Your script needs to know exactly which file the AI agent modified to maximize the `AfterTool` hook. We achieve this through path injection via the tool's input.

The Gemini CLI passes the context of the tool execution to the script via standard input (`stdin`). You can extract the `file_path` from this JSON payload.

Here is a bash script example (`after_write.sh`). It reads the injected path, formats the file, and runs analysis:

```bash
#!/bin/bash

# Read the tool input via stdin
INPUT=$(cat)

# Extract the file_path using jq
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# 1. Auto-format the specific file immediately
if [[ -n "$FILE_PATH" && "$FILE_PATH" == *.dart ]]; then
    dart format "$FILE_PATH" > /dev/null 2>&1
fi

# 2. Run analysis on the specific file
OUTPUT=$(dart analyze "$FILE_PATH" 2>&1)

if echo "$OUTPUT" | grep -q "No issues found!"; then
    echo '{"decision": "allow"}'
else
    CLEAN_OUTPUT=$(echo "$OUTPUT" | sed '1d')
    jq -n --arg output "$CLEAN_OUTPUT" '{decision: "deny", reason: ("Lint issues found: " + $output), systemMessage: "⚠️ Lint issues found!"}'
fi
```

Passing `$FILE_PATH` directly to `dart format` ensures no poorly formatted code is persisted. If `dart analyze` finds issues, the script returns a `deny` decision. It feeds the exact error back to the agent for self-correction.

## Running the Build Runner

Dart and Flutter development heavily rely on code generation for tools like JSON serialization, Freezed, or Riverpod. Manually triggering the build runner after an AI modifies a file breaks your flow.

You can automate this process with the `AfterTool` hook and path injection. It runs the build runner specifically for the changed file.

You can conditionally trigger code generation by checking the injected file path:

```bash
#!/bin/bash

# Read stdin and extract file path
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Check if it's a Dart file that requires code generation
if [[ -n "$FILE_PATH" && "$FILE_PATH" == *.dart ]]; then
    
    if grep -q "part '.*\.g\.dart';" "$FILE_PATH" || grep -q "part '.*\.freezed\.dart';" "$FILE_PATH"; then
        
        FILTER_PATH="${FILE_PATH%.dart}.*.dart"
        
        # Run the build runner with a filter
        OUTPUT=$(dart run build_runner build --build-filter="$FILTER_PATH" --delete-conflicting-outputs 2>&1)
        
        if [ $? -ne 0 ]; then
            # If code generation fails, deny the tool execution
            jq -n --arg output "$OUTPUT" '{decision: "deny", reason: ("Code generation failed for " + $FILE_PATH + ":\n" + $output), systemMessage: "⚠️ Build Runner failed!"}'
            exit 0
        fi
    fi
fi

# Allow if everything succeeded
echo '{"decision": "allow"}'
```

Using `--build-filter` makes code generation highly efficient. It targets only the file the agent modified, rather than re-evaluating the entire project graph.

## The Future of AI Alignment Loops

Hooks like `AfterTool` and `AfterAgent` fundamentally change how we interact with AI agents. I am convinced we are moving away from asking models to double-check their work. Instead, we are building robust systems that physically enforce quality.

This automated verification loop will soon become deeply integrated into daily workflows:

- **Intelligent Scoping:** Hooks will get smarter at determining what needs testing. If a utility function changes, the hook will run only the dependent unit tests.
- **Ecosystem Tooling:** Community repositories of pre-built hooks will emerge. Dropping enterprise-grade CI/CD checks into your local AI environment will be trivial.
- **True Autonomy:** These deterministic checks close the trust gap. Developers will confidently run agents in fully autonomous modes for longer durations. You will know the code compiles and passes lints before you review it.

The `AfterTool` hook proves a powerful concept. Combining the creative speed of LLMs with strict software tooling achieves high productivity and code quality.