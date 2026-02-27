---
title: "A 3-Step Gemini CLI Agentic Workflow for Reliable Code Generation with Dart and Jaspr"
description: "Learn how to build an iterative agentic workflow for reliable code generation. Discover the Alignment Loop using Gemini CLI, Dart, and Jaspr to verify AI code."
date: 2026-02-24
slug: gemini-cli-ai-agentic-workflow-with-dart-jaspr
tags: ["Gemini CLI", "Dart","Agentic Workflow"]
---

When building an agentic workflow for code generation using AI tools like the Gemini CLI, generating code is easy. Generating *correct* code is the real challenge. Without guardrails, an LLM hallucinates solutions. It assumes success simply because it outputs text that looks like code.

To solve this, I use a workflow I call **The Alignment Loop**. 

The Alignment Loop is an iterative, self-correcting workflow that forces the AI agent to verify its own work through a series of strict checks. Instead of writing code and stopping, the agent must prove its implementation works by passing static analysis, framework compilation, and a final, independent quality assurance check.

Here is how I use the [Gemini CLI](https://github.com/google/gemini-cli) and the [Jaspr](https://jaspr.site) framework (as detailed in my [previous post on building this static site](https://thiele.dev/blog/dart-jaspr-static-site-gemini-cli/)) to iterate between my prompt and the output.

---

## Why reliable code generation needs the Alignment Loop

The core problem with autonomous coding is the gap between intent (the prompt) and reality (the output). If an agent makes a mistake—a typo, a misunderstood API, or a broken layout—and doesn't realize it, it confidently presents a broken solution. 

The Alignment Loop forces the agent to face reality. By embedding strict verification steps directly into the project's instructions (via a `GEMINI.md` file), the agent is forced into an autonomous cycle:

1.  **Generate/Edit Code.**
2.  **Verify.**
3.  **If verification fails, automatically fix it.**

This prevents the AI from hallucinating success. Let's break down the three steps that make up this loop.

---

## Step 1: `dart analyze` (the foundation)

This is the first and most critical step. Before any framework-specific builds or tests run, the raw [Dart](https://dart.dev) code must be structurally sound and strictly adhere to project conventions.

In my `dart-dev` skill, I define a mandatory verification workflow. After any code change, the agent must run the static analyzer:

```markdown
> AFTER making code changes and BEFORE considering a task complete, you MUST:
> 1. **Analyze:** Run `dart analyze` and fix ALL reported errors, warnings, and info messages (including deprecations).
```

This acts as the first gate. By enforcing strong typing and strict linting (via `analysis_options.yaml`), the agent catches syntax errors, missing imports, or type mismatches early. This prevents cascading failures later. It forces the LLM to write high-quality, idiomatic Dart code rather than just "getting it to work."

## Step 2: `jaspr build` (the compilation check)

Once the code passes static analysis, the next step is to ensure the specific framework can successfully compile and render the project. For my blog, this means validating the logic and component structure with Jaspr.

My `jaspr` skill introduces a strict "No-Shortcut Policy." It explicitly states that the build process cannot be skipped, regardless of how "trivial" or "safe" a change might seem.

```markdown
> ### No-Shortcut Policy
> - **Never skip the build:** Even for "trivial" or "safe" changes (like paths, text, or CSS), a build is required to ensure no regressions or syntax errors were introduced.
> - **Final Tool Call:** The last tool call in any turn that modifies the codebase or assets MUST be `jaspr build` (or a command that includes it).
```

Before the agent even communicates back to me, it must internally verify: "Did I run `jaspr build` in this turn?" If not, it runs it. If it fails, it resolves the error autonomously. This catches issues like DOM naming collisions, SSR/hydration mismatches, or syntax errors in CSS-in-Dart that static analysis might miss.

## Step 3: The `tester` agent (quality assurance)

Passing analysis and compilation doesn't guarantee the code actually *does* what was requested. The final step delegates quality assurance to a specialized sub-agent to verify the output against the original prompt.

I have a custom `tester` agent (`.gemini/agents/tester.md`) designed specifically to inspect the generated HTML output. 

Its workflow is straightforward:
1.  **Build:** Run `jaspr build` to ensure it's testing the absolute latest output.
2.  **Analyze Requirements:** Translate my original feature request into expected HTML structures.
3.  **Inspect Output:** Actively search the generated files in the `/build/jaspr/` directory using `grep` for the expected elements, classes, or content.
4.  **Report:** Generate a structured report comparing "Expected" vs. "Found" results, along with a confidence score.

Delegating this to a specialized agent provides the primary coding agent with objective, tool-driven feedback. It verifies if the implementation successfully produced the desired outcome.

**Example Verification Report:**

> **Expected:** The "Community & Recognition" section on the "About" page should include the role "Google Developer Expert (GDE) for Flutter".
>
> **Found:** After running `jaspr build`, the generated file `build/jaspr/about/index.html` was verified. The requested text is successfully included in the rendered HTML.
>
> **Snippet from `build/jaspr/about/index.html`:**
> ```html
> <h2 id="community--recognition"><span>Community & Recognition</span>...</h2>
> <ul>
>   <li>
>     <strong>2023 - Present</strong>: Google Developer Expert (GDE) for Flutter
>   </li>
> </ul>
> ```
> **Confidence: 100%**
>
> **Result: The task is properly completed.**

## Automating the loop: the project mandate

The individual steps are only powerful if consistently executed. To automate this, I enforce the continuous loop at the project level via the `GEMINI.md` file:

```markdown
> - **Verification:** ALWAYS after ANY edit, spawn the `tester` agent and ask if the actual task is completed. If not, fix it automatically until the `tester` agent confirms completion.
```

This single line is the engine of the Alignment Loop. It forces the agent into an iterative, self-correcting cycle. If the static analysis fails, it fixes it. If the build fails, it fixes it. If the tester agent reports that the expected HTML isn't there, it fixes it. 

Through this series of checks, I rely on the Gemini CLI to not just write code, but to deliver verified, working solutions.

---

## Beyond Prompts: Enforcing the Loop with Hooks

However, even with these strict instructions, an agent can still occasionally "drift" and skip a verification step. To move from *asking* the agent to follow a loop to *enforcing* it through automation, I use **Gemini CLI Hooks**. You can [read more about how I automated the Alignment Loop here](https://thiele.dev/blog/gemini-cli-hooks-automating-the-ai-alignment-loop/).