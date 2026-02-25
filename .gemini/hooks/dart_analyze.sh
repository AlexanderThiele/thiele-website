#!/bin/bash

# Format the code first (silently)
dart format lib > /dev/null 2>&1

# Run dart analyze and capture its output
# We use -n in echo and capture to be safe, but dart analyze default is fine.
# We'll filter out the "Analyzing..." and time to keep it clean.

OUTPUT=$(dart analyze lib 2>&1)

# Check if there are any issues by looking for "No issues found!"
if echo "$OUTPUT" | grep -q "No issues found!"; then
    # All good
    echo '{"decision": "allow"}'
else
    # Issues found.
    # Filter out the first line which contains the analysis duration (it's noisy and can change)
    # Also filter out empty lines or the trailing line if it's just "X issues found."
    # Actually, keeping "X issues found." might be helpful.
    
    # We'll just provide the raw output (minus the time-based first line) as the reason.
    CLEAN_OUTPUT=$(echo "$OUTPUT" | sed '1d')
    
    # Use jq to construct the JSON response.
    # This will deny the turn and provide the lint errors back to the agent as a new prompt.
    jq -n --arg output "$CLEAN_OUTPUT" '{decision: "deny", reason: ("The codebase has lint issues. Please fix ALL errors, warnings, and info messages (including deprecations):" + $output), systemMessage: "⚠️ Lint issues found!"}'
fi
