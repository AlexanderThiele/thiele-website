---
name: dart-jaspr-dev
description: Expert guidance for developing Dart applications with the Jaspr framework and jaspr_content. Use when creating or modifying Jaspr components, managing content-driven sites, or optimizing Dart code for both server and client environments.
---

# Dart Jaspr Dev

## Overview
This skill provides specialized knowledge for building documentation-heavy websites using Jaspr and `jaspr_content`. It covers component design, routing, content integration, and the dual server/client execution model.

## Core Principles

### 1. The Jaspr Model
- **Server-Side Rendering (SSR):** Most components should render on the server for SEO and performance. Use `lib/main.server.dart` for global configuration.
- **Client-Side Hydration:** Use the `@client` annotation for components requiring interactivity or state.
- **Isomorphic Code:** Use `package:jaspr/dom.dart` for DOM-like elements and `package:jaspr/jaspr.dart` for core component logic.

### 2. Content Management with `jaspr_content`
- **Markdown-First:** Content lives in the `content/` directory.
- **Custom Components:** Register components in `lib/main.server.dart` using `CustomComponent(pattern: 'Name', builder: ...)` to use them inside Markdown files as `<Name />`.
- **Mustache Templates:** Enable `MustacheTemplateEngine()` in `ContentApp` to allow dynamic content injection in Markdown.

### 3. Component Design
- **Stateful vs. Stateless:** Use `StatefulComponent` when local state is needed (common for `@client` components).
- **Styling:** Prefer Jaspr's `@css` annotation within components for scoped, type-safe styling.
- **Layouts:** Utilize `DocsLayout` for standard documentation structures, configuring the `header` and `sidebar` in the root `ContentApp`.

## Workflows

### Adding a New Page
1. Create a Markdown file in `content/`.
2. Add the path to the `Sidebar` configuration in `lib/main.server.dart` if it needs to be visible in navigation.

### Creating an Interactive Component
1. Create a new file in `lib/components/`.
2. Define a `StatefulComponent` and annotate it with `@client`.
3. Register the component in `lib/main.server.dart` if it needs to be used in Markdown.

### Styling Components
- Use the `@css` static getter returning `List<StyleRule>`.
- Reference `ContentColors` from `package:jaspr_content/theme.dart` to maintain theme consistency.

## Best Practices
- **Type Safety:** Ensure all props are typed and documented.
- **Performance:** Minimize the number of `@client` components to reduce bundle size.
- **Linting:** Strictly follow `analysis_options.yaml`. Run `dart analyze` before committing.
- **Build:** Use `jaspr build` to verify that both server and client targets compile correctly.
