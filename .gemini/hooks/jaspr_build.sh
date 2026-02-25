#!/bin/bash

# Run jaspr build and capture output
OUTPUT=$(jaspr build 2>&1)

# Check if the build was successful (exit code 0)
if [ $? -eq 0 ]; then
    # All good
    echo '{"decision": "allow"}'
else
    # Build failed
    # Filter out noisy or repetitive parts of the build output if necessary.
    # We'll just provide the raw output as the reason for now.
    
    # Use jq to construct the JSON response.
    # This will deny the turn and provide the build error back to the agent.
    jq -n --arg output "$OUTPUT" '{decision: "deny", reason: ("The Jaspr build failed. Please fix the build issues:\n\n" + $output), systemMessage: "⚠️ Jaspr build failed!"}'
fi
