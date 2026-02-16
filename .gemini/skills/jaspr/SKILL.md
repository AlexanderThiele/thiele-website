---
name: jaspr
description: Expert guidance for the Jaspr framework and jaspr_content. Use for component design (SSR/Hydration), content engines, CSS-in-Dart styling, and Jaspr-specific build workflows.
---

# Jaspr Framework Dev

## Core Principles

### 1. Execution Model
- **Server-Side Rendering (SSR):** Preferred for SEO and initial load. Global config in `lib/main.server.dart`.
- **Client-Side Hydration:** Use `@client` for stateful/interactive components.
- **Isomorphic Code:** Favor `package:jaspr/jaspr.dart` for core logic and `package:jaspr/dom.dart` for HTML elements.

### 2. Content Management (`jaspr_content`)
- **Eager Loading:** Enable `eagerlyLoadAllPages: true` in `ContentApp` to access metadata for all pages.
- **Programmatic Access:** If `ContentContext.of(context).pages` is inaccessible, manually read the `content/` directory using `Directory('content/blog').listSync()` and parse Markdown files.
- **Frontmatter Parsing:** When manually parsing, split content by `---` and extract keys like `title:`, `date:`, and `description:`.
- **Frontmatter Access in Layouts:** Inside a custom `PageLayout`, access frontmatter via `page.data.page['your_key']`.

### 3. Custom Layouts
- **Implementation:** Extend `PageLayout` or `PageLayoutBase`. `PageLayoutBase` provides default `buildHead` logic for SEO tags.
- **Member Implementation:** If extending `PageLayout`, implement `buildLayout(Page page, Component child)`. If extending `PageLayoutBase`, implement `buildBody(Page page, Component child)`.
- **Layout Styling:** To include layout-specific global styles, override `buildHead` and yield a `Style` component: `yield Style(styles: _styles);`.
- **DocsLayout Limitations:** `DocsLayout` does not have built-in flags to hide the title/description. Use a custom layout for full control over the `content-header`.
- **Header Navigation:** The `Header` component from `jaspr_content` accepts an `items` list of components, ideal for top-level navigation links.
- **DOM Naming:** Use `main_()` for the `<main>` tag to avoid name collisions with the Dart `main()` function.

### 4. Styling (CSS-in-Dart)
- **Typed API Enums:** 
  - `Display.flex`, `Display.grid`, `Display.none`.
  - `AlignItems.start`, `AlignItems.center`, `AlignItems.end`.
  - `FlexDirection.row`, `FlexDirection.column`.
  - `FontWeight.w400` (normal), `FontWeight.w600` (semibold), `FontWeight.w700` (bold), `FontWeight.w800` (extrabold).
- **Units & Spacing:** Use extensions like `.rem`, `.px`, `.percent`, or `Unit.auto`. For `.all(Unit.zero)`, use `Unit.zero` instead of `0`.
- **Raw Styles:** Use `raw: {}` for:
  - `grid-template-columns: 'repeat(auto-fit, minmax(420px, 1fr))'`.
  - `gap: '3rem'` (if `Gap()` constructor fails).
  - `aspect-ratio: '2 / 1'`, `object-fit: 'cover'`.
  - `border: '1px solid rgba(0, 0, 0, 0.2)'`.
  - `text-decoration: 'underline'`.

## Workflows

### Creating a Blog Overview
1. Create a component that uses `dart:io` to list `.md` files in `content/blog/`.
2. Parse the frontmatter of each file to extract `title`, `date`, and `description`.
3. Render using a `ul` with `Display.grid` and `auto-fit` for responsiveness.
4. Sort posts by `date` descending.

## Mandatory Verification Workflow
AFTER making code changes and BEFORE considering a task complete, you MUST:
1. **Build:** Run `jaspr build` and verify successful completion.

### No-Shortcut Policy
- **Never skip the build:** Even for "trivial" or "safe" changes (like paths, text, or CSS), a build is required to ensure no regressions or syntax errors were introduced.
- **Final Tool Call:** The last tool call in any turn that modifies the codebase or assets MUST be `jaspr build` (or a command that includes it).

### Pre-Response Check
Before sending a text response to the user after a modification:
- "Did I run `jaspr build` in this turn?"
- If NO, run it now.
- If YES but it failed, resolve the error.

## Common Issues
- **highlighter crash:** `CodeBlock()` from `jaspr_content` may throw "Null check operator used on a null value" due to complex language hints or missing theme colors. Disable it in `lib/main.server.dart` if it blocks the build.
- **OptionsSkew:** If `jaspr build` fails with `OptionsSkew`, run `pkill -f dart && pkill -f jaspr` and try again.
- **Import Errors:** Ensure `package:jaspr/dom.dart` is used for HTML tags and `package:jaspr/jaspr.dart` for core components.
