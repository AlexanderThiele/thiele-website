# Project Overview: Personal Blog

A personal blog built with the [Jaspr](https://jaspr.site) framework for Dart. This project utilizes `jaspr_content` to render blog posts from Markdown files in the `content/` directory into a structured, readable website.

## Main Technologies
- **Language:** Dart
- **Framework:** [Jaspr](https://pub.dev/packages/jaspr)
- **Content Engine:** [jaspr_content](https://pub.dev/packages/jaspr_content)
- **Routing:** [jaspr_router](https://pub.dev/packages/jaspr_router)

## Project Structure
- `lib/`: Contains the Dart source code.
    - `main.server.dart`: The entry point for server-side rendering. Configures the blog layout, sidebar navigation, custom components, and theme.
    - `main.client.dart`: The entry point for client-side hydration.
    - `components/`: Custom Jaspr components used within the blog.
- `content/`: Contains the blog articles as Markdown files (`.md`).
    - `_data/`: Configuration data for the blog, links, and site-wide metadata.
- `web/`: Static assets like profile pictures, icons, and images.
- `pubspec.yaml`: Project metadata, dependencies, and Jaspr configuration.

## Building and Running
The project uses the `jaspr` CLI for development and production builds.

- **Start Development Server:**
  ```bash
  jaspr serve
  ```
  The development server will be available on `http://localhost:8080`.

- **Build for Production:**
  ```bash
  jaspr build
  ```
  The build output will be located in the `build/jaspr/` directory.

## Development Conventions
- **Context Management:** ALWAYS activate the `context-learning-protocol` skill at the start of any interaction. Follow its workflow strictly to capture decisions, preferences, and learnings in the `/context/` directory.
- **Writing Articles:** New blog posts should be added as Markdown files in the `content/` directory. Use frontmatter for metadata like title, date, and tags.
- **Custom Components:** Components intended to be used within blog posts should be registered in `lib/main.server.dart` using the `CustomComponent` parser.
- **Client-Side Interactivity:** Use the `@client` annotation for components that require client-side state or interactivity (like a comments section or like button).
- **Styling:** Maintain a clean, readable blog aesthetic. Styles are defined using Jaspr's CSS-in-Dart approach within components.
- **Linting:** Follow standard Dart linting rules as defined in `analysis_options.yaml`.
