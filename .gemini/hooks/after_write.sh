#!/bin/bash

# Read stdin into a variable
INPUT=$(cat)
echo "DEBUG: after_write.sh INPUT: $INPUT" >&2

# Extract tool_name and tool_input
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only process .dart files that exist
if [[ -n "$FILE_PATH" && "$FILE_PATH" == *.dart && -f "$FILE_PATH" ]]; then
    # Run dart format on the file
    dart format "$FILE_PATH" > /dev/null 2>&1

    # Run dart analyze on the file
    OUTPUT=$(dart analyze "$FILE_PATH" 2>&1)

    # Check if there are any issues
    if echo "$OUTPUT" | grep -q "No issues found!"; then
        # All good
        echo '{"decision": "allow"}'
    else
        # Issues found
        # Filter out the first line which contains the analysis duration
        CLEAN_OUTPUT=$(echo "$OUTPUT" | sed '1d')
        
        # Deny the tool response and show the analyze output
        jq -n \
           --arg output "$CLEAN_OUTPUT" \
           --arg tool "$TOOL_NAME" \
           --arg file "$FILE_PATH" \
           '{
             decision: "deny",
             reason: ("The tool \($tool) was executed, but dart analyze found issues in \($file). Please fix ALL errors, warnings, and info messages:\n\($output)"),
             systemMessage: "⚠️ Lint issues found after \($tool)"
           }'
    fi
else
    # Not a .dart file or file doesn't exist, just allow
    echo '{"decision": "allow"}'
fi
