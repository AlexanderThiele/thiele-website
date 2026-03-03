#!/bin/bash

# Read stdin into a variable
INPUT=$(cat)

# Extract tool_name and tool_input
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# If it's a .dart file, format it.
if [[ -n "$FILE_PATH" && "$FILE_PATH" == *.dart ]]; then
    # Run dart format on the file
    dart format "$FILE_PATH" > /dev/null 2>&1
fi

# Run dart analyze lib and capture its output
SCOPE="lib"

# Check if lib directory exists
if [ ! -d "$SCOPE" ]; then
    echo '{"decision": "allow"}'
    exit 0
fi

OUTPUT=$(dart analyze "$SCOPE" 2>&1)

# Check if there are any issues
if echo "$OUTPUT" | grep -q "No issues found!"; then
    # All good
    echo '{"decision": "allow"}'
else
    # Issues found
    # Filter out the first line which contains the analysis duration (it's noisy and can change)
    CLEAN_OUTPUT=$(echo "$OUTPUT" | sed '1d')
    
    # Deny the tool response and show the analyze output
    # Using jq with string interpolation for better robustness
    jq -n \
       --arg output "$CLEAN_OUTPUT" \
       --arg tool "$TOOL_NAME" \
       '{
         decision: "deny",
         reason: ("The tool \($tool) was executed, but dart analyze found issues in the codebase. Please fix ALL errors, warnings, and info messages (including deprecations):\n\($output)"),
         systemMessage: "⚠️ Lint issues found after \($tool)"
       }'
fi
