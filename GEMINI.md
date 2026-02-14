# Project Overview: website

A documentation site built with the [Jaspr](https://jaspr.site) framework for Dart. This project utilizes `jaspr_content` to render Markdown files from the `content/` directory into a structured documentation website.

## Main Technologies
- **Language:** Dart
- **Framework:** [Jaspr](https://pub.dev/packages/jaspr)
- **Content Engine:** [jaspr_content](https://pub.dev/packages/jaspr_content)
- **Routing:** [jaspr_router](https://pub.dev/packages/jaspr_router)

## Project Structure
- `lib/`: Contains the Dart source code.
    - `main.server.dart`: The entry point for server-side rendering. Configures the `ContentApp`, including layout, sidebar, components, and theme.
    - `main.client.dart`: The entry point for client-side hydration.
    - `components/`: Custom Jaspr components (e.g., `Clicker`).
- `content/`: Contains the Markdown files (`.md`) that serve as the site's pages.
    - `_data/`: Configuration data for the site and links.
- `web/`: Static assets like icons and images.
- `pubspec.yaml`: Project metadata, dependencies, and Jaspr configuration.
- `analysis_options.yaml`: Linting rules for the project.

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
- **Content Management:** New pages should be added as Markdown files in the `content/` directory.
- **Custom Components:** Components intended to be used within Markdown files should be registered in `lib/main.server.dart` using the `CustomComponent` parser.
- **Client-Side Interactivity:** Use the `@client` annotation for components that require client-side state or interactivity (like `Clicker`).
- **Styling:** Styles can be defined using Jaspr's CSS-in-Dart approach (e.g., using `@css` annotations in components).
- **Linting:** The project follows standard Dart linting rules as defined in `analysis_options.yaml`.
