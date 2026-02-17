/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

// Server-specific Jaspr import.
import 'dart:io';

import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:jaspr_router/jaspr_router.dart' hide RouteLoader;

import 'components/clicker.dart';
import 'components/blog_grid.dart';
import 'components/hero.dart';
import 'components/app_layout.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

import 'package:jaspr/dom.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [ContentApp] spins up the content rendering pipeline from jaspr_content to render
  // your markdown files in the content/ directory to a beautiful documentation site.
  runApp(
    ContentApp.custom(
      eagerlyLoadAllPages: true,
      loaders: [FilesystemLoader('content')],
      configResolver: PageConfig.all(
        templateEngine: MustacheTemplateEngine(),
        parsers: [
          MarkdownParser(),
        ],
        extensions: [
          // Adds heading anchors to each heading.
          HeadingAnchorsExtension(),
          // Generates a table of contents for each page.
          TableOfContentsExtension(),
        ],
        components: [
          // The <Info> block and other callouts.
          Callout(),
          // Adds a custom Jaspr component to be used as <Clicker/> in markdown.
          CustomComponent(
            pattern: 'Clicker',
            builder: (_, _, _) => Clicker(),
          ),
          CustomComponent(
            pattern: 'Hero',
            builder: (name, attrs, child) => Hero(
              title: attrs['title'],
              content: attrs['content'],
              image: attrs['image'],
            ),
          ),
          CustomComponent(
            pattern: 'BlogGrid',
            builder: (name, attrs, child) => BlogGrid(
              title: attrs['title'],
            ),
          ),
          // Adds zooming and caption support to images.
          Image(zoom: true),
        ],
        layouts: [
          AppLayout(
            header: Header(
              title: 'Alexander Thiele',
              logo: '/images/logo.svg',
              leading: [],
              items: [
                a(classes: 'header-link', href: '/', [Component.text('Home')]),
                a(classes: 'header-link', href: '/blog', [Component.text('Blog')]),
                a(classes: 'header-link', href: '/about', [Component.text('About')]),
                ThemeToggle(),
              ],
            ),
          ),
        ],
        theme: ContentTheme(
          // Customizes the default theme colors.
          primary: ThemeColor(ThemeColors.blue.$500, dark: ThemeColors.blue.$300),
          background: ThemeColor(ThemeColors.slate.$50, dark: ThemeColors.zinc.$950),
          colors: [
            ContentColors.quoteBorders.apply(ThemeColors.blue.$400),
          ],
        ),
      ),
      routerBuilder: (routes) {
        final flatRoutes = routes.expand((r) => r).toList();
        
        // Find blog routes and override their paths if they have a slug
        for (var i = 0; i < flatRoutes.length; i++) {
          final r = flatRoutes[i];
          if (r is Route && r.path.startsWith('/blog/')) {
            final fileName = r.path.substring(6);
            if (fileName.isEmpty || fileName == 'index') continue;

            // Try to find the file and read the slug
            final file = File('content/blog/$fileName.md');
            if (file.existsSync()) {
              final content = file.readAsStringSync();
              final match = RegExp(r'slug:\s*(.*)').firstMatch(content);
              if (match != null) {
                final slug = match.group(1)!.trim();
                flatRoutes[i] = Route(
                  path: '/blog/$slug',
                  builder: r.builder,
                  routes: r.routes,
                );
              }
            }
          }
        }
        
        return Router(routes: flatRoutes);
      },
    ),
  );
}
