# Bash Scripting: Avoid Line Breaks in jq Commands

## Type
Learning

## Date
2026-02-25

## Description
A syntax error was discovered in a bash script where a `jq` command was split across two lines without a line continuation character (``).

## Context/Reasoning
In the `.gemini/hooks/dart_analyze.sh` script, the `jq` command was written as:
```bash
    jq -n --arg output "$CLEAN_OUTPUT" 
       '{decision: "deny", ...}'
```
Bash interprets the newline as the end of the command, causing `jq` to be executed with only the `--arg` options, leading it to display its help menu instead of processing the intended filter.

## Actionable Item
Always ensure that multi-line bash commands use the line continuation backslash (``) or, if possible, keep the command on a single line for clarity and to prevent unexpected termination.
