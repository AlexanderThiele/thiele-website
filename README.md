# Alexander Thiele's Personal Blog

Welcome to the repository for my personal blog! This site is statically generated and built entirely using Dart.

## Technology Stack

*   **Language:** [Dart](https://dart.dev/)
*   **Framework:** [Jaspr](https://jaspr.site/) - A modern web framework for building websites in Dart.
*   **Content Management:** [jaspr_content](https://pub.dev/packages/jaspr_content) - Used for rendering Markdown files into static HTML pages.
*   **Static Site Generation (SSG):** The site is pre-built as static HTML, CSS, and JS files, ensuring fast load times, robust security, and excellent SEO.

## Development

To run this project locally, you will need the Dart SDK and the Jaspr CLI installed.

1.  **Install Jaspr CLI:**
    ```bash
    dart pub global activate jaspr_cli
    ```

2.  **Fetch Dependencies:**
    ```bash
    dart pub get
    ```

3.  **Run in Development Mode:**
    ```bash
    jaspr serve
    ```

## Building for Production

To generate the final static site output:

```bash
jaspr build
```

The compiled static assets will be located in the `build/jaspr/` directory, ready to be deployed to any static hosting provider.
