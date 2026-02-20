---
title: "Building a Static Site with Dart, Jaspr, and Gemini CLI"
description: "Learn how to build high-performance static sites using Dart, the Jaspr web framework, and the Gemini CLI. Explore AI-assisted web development workflows."
date: 2026-02-20
slug: dart-jaspr-static-site-gemini-cli
tags: ["flutter", "gemini cli", "ai"]
---

Web development today pushes for performance, security and speed. While traditional dynamic sites rely on server-side rendering per request, static site generation is a strong alternative. Let's explore building a static site with Dart and the Jaspr framework, using the Gemini CLI as an AI assistant.

## Fundamentals of Dart and Static Site Generation

Before diving into the workflow, let's look at the underlying technologies: Dart and static site generators.

### The Role of Dart

Google developed [Dart](https://dart.dev/) as a client-optimized programming language. Known as the foundation for Flutter, it offers significant advantages for web development. Key characteristics include:

*   **Multi-Platform Compilation**: Dart supports ahead-of-time compilation for native execution, just-in-time compilation for hot reloads, and JavaScript transpilation for the web.
*   **Robustness**: The language is object-oriented and strongly typed with sound null safety. This eliminates many runtime errors and ensures code reliability.
*   **Isomorphic Capabilities**: Dart runs natively on a server via the Dart Virtual Machine and in the browser via compiled JavaScript. This lets you use the same code for server and client without context switching.

### The Power of Static Site Generation

A static site generator automates the creation of HTML websites from raw data and templates. This contrasts sharply with traditional dynamic sites.

In a dynamic setup, a server processes scripts and queries databases to assemble HTML on every request. An SSG shifts this to a one-time build phase. The developer writes content in Markdown and runs a build command. The SSG merges the content with templates to output standard HTML, CSS and JavaScript files.

The benefits are clear:

*   **Speed**: Pre-built files served from a content delivery network ensure near-instantaneous load times.
*   **Security**: Without databases or server-side scripts running on request, there are no vulnerabilities to common exploits like SQL injection.
*   **Scalability**: Serving static files requires minimal processing power, allowing the site to handle traffic spikes effortlessly.

## What is Jaspr? A Dart Web Framework

[Jaspr](https://pub.dev/packages/jaspr) is a web framework that brings Dart to web development by using its isomorphic capabilities.

Instead of relying purely on client-side rendering, Jaspr executes Dart code during a CI/CD build phase (such as a GitHub Actions workflow). This process generates the raw HTML files necessary for search engine optimization and fast initial loads, which can then be deployed to a CDN like Netlify. Once the browser receives the page, Jaspr "hydrates" it with compiled JavaScript to add interactivity. This provides the performance of a static site with the dynamic capabilities of a modern web application.

For example, a typical [deployment workflow](https://github.com/AlexanderThiele/thiele-website/blob/main/.github/workflows/deploy.yml) involves the following steps:
1.  **Setting up the Environment**: Checking out the repository and installing Dart.
2.  **Fetching Dependencies**: Running `dart pub get` to download required packages.
3.  **Installing Jaspr CLI**: Activating the `jaspr_cli` globally.
4.  **Building the Site**: Executing `jaspr build` to generate the static HTML, CSS, and JavaScript files.
5.  **Deployment**: Uploading the generated `build/jaspr` directory to a hosting provider like Netlify.

## Integrating the AI Agent: Gemini CLI

The Gemini CLI, an AI terminal assistant, can accelerate Jaspr development. It manages coding tasks, navigates the file system, and enforces project conventions through custom configurations called "skills."

The workflow relies on specific instructions to ensure the agent writes correct, idiomatic code.

### What Are Skills?

A Gemini CLI "skill" is a localized configuration that extends the agent's capabilities with specialized knowledge, workflows and rules. Skills provide targeted expertise for a particular domain or technology stack instead of a generalized AI prompt. Activating a skill lets developers enforce architectural constraints, mandate tool usage, and guide the agent to follow project conventions.

### The Jaspr Skill

A custom skill configuration transforms the generic AI into a specialized Jaspr developer. This defines strict rules for the agent to follow, minimizing hallucinations and ensuring alignment with current best practices.

### Documentation Queries with Context7

Because Jaspr is an evolving framework, relying on the AI's base training data often leads to outdated code patterns. The skill resolves this by mandating the Context7 MCP server as the primary documentation source.

The process involves two steps:
1.  **Resolving the Library ID**: The agent queries for the base Jaspr library ID (`/schultek/jaspr`), which indexes documentation for all Jaspr sub-packages.
2.  **Pre-Code Queries**: Before writing code, the agent queries the official documentation for specific examples and API references. This ensures features like server-side rendering or CSS-in-Dart are correct on the first attempt.

## Ensuring Quality and Accuracy

Beyond querying documentation, the workflow requires rigorous verification.

### The Mandatory Build Step

The Jaspr skill enforces a "no-shortcut policy." It mandates that the final action after modifying the codebase must be executing the `jaspr build` command. 

This applies even to minor text or styling changes. Forcing a build lets the AI immediately identify unintended consequences like broken import paths or syntax errors. The agent also performs an internal pre-response check. If the build fails, it autonomously resolves the error before reporting back. This self-healing loop keeps the project in a compilable state.

Developers also rely on tools like `dart analyze` to ensure code quality, which the agent can incorporate into its verification process.

## Automating Asset Generation

A complete website requires assets like Open Graph images for social sharing. The Gemini CLI uses a zero-dependency workflow to generate these natively on macOS with built-in tools.

This process uses the "square canvas" pattern to overcome limitations in the macOS `qlmanage` utility, which tends to distort rectangular SVGs into square thumbnails:

1.  **Creating the SVG**: The agent generates a perfectly square SVG canvas, like 1200x1200px, and centers the target rectangular content, like 1200x630px, within it.
2.  **Rendering**: The `qlmanage` tool processes the square SVG into an undistorted, square PNG.
3.  **Cropping**: The `sips` (Scriptable Image Processing System) tool performs a centered crop, removing the top and bottom margins to produce the correctly proportioned hero image.

This use of native tools eliminates the need for external image processing libraries.

## Conclusion

Combining Dart, Jaspr and a highly constrained AI agent presents a powerful paradigm for web development. Developers can build fast and secure websites by using Dart's multi-platform strengths and Jaspr's isomorphic static site generation. Integrating an AI assistant like the Gemini CLI—guided by custom skills, Context7 documentation and mandatory build verifications—ensures the resulting codebase remains accurate, idiomatic and maintainable.

Explore the open-source repository for the project discussed in this article on GitHub: [AlexanderThiele/thiele-website](https://github.com/AlexanderThiele/thiele-website).