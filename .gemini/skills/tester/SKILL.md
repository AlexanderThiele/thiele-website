---
name: tester
description: A skill for verifying if the generated HTML output matches the expected task. Use this to ensure that Jaspr builds produce the correct structural and content results after a code change.
---

# Tester

## Overview
This skill provides a systematic approach to verifying that the final rendered HTML matches the intended behavior and design of a task. It's particularly useful for projects using the Jaspr framework to ensure that components and content are correctly transformed into static or hydrated HTML.

## Verify Mode
The `verify-mode` is used to validate the completion of a task by inspecting the actual build output.

### Workflow

1.  **Build the Project:**
    Run the `jaspr build` command to generate the latest version of the rendered HTML in the output directory.
    ```bash
    jaspr build
    ```
    *Note: Ensure you are in the project root.*

2.  **Analyze Requirements:**
    Re-examine the original task or feature request to understand exactly what HTML elements, attributes, or content should be present in the final output.

3.  **Inspect Rendered HTML:**
    Navigate to the `/build/jaspr/` directory (or the configured output directory) and locate the relevant HTML files. Use tools like `read_file` or `grep_search` to find specific patterns.

4.  **Verification Report:**
    If the verification fails or needs clarification, provide a report with the following:
    - **Expected:** What you expected to see in the HTML.
    - **Found:** What was actually present (provide a snippet if possible).
    - **Confidence:** Your level of confidence (0-100%) that the task is properly completed.

## Examples

### Example 1: Verifying a New Component
**Task:** Add a `Hero` component with a background image.
1.  Run `jaspr build`.
2.  Check `build/jaspr/index.html`.
3.  Search for `<div class="hero"` and verify the `style` attribute contains the correct background image URL.

### Example 2: Verifying Blog Post Content
**Task:** Ensure the "About" page has a "Contact Me" section.
1.  Run `jaspr build`.
2.  Check `build/jaspr/about.html`.
3.  Search for an `<h2>` or `<h3>` containing "Contact Me".
