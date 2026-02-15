/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

import 'components/clicker.dart';
import 'components/blog_grid.dart';
import 'components/hero.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

import 'package:jaspr/dom.dart';

class BlogLayout extends PageLayoutBase {
  final Header? header;

  BlogLayout({this.header});

  @override
  String get name => 'blog';

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page);
    yield Style(styles: _styles);
  }

  @override
  Component buildBody(Page page, Component child) {
    return div(
      classes: 'docs',
      [
        if (header != null)
          div(classes: 'header-container', [
            header!,
          ]),
        div(
          classes: 'main-container',
          [
            main_([
              div([
                div(
                  classes: 'content-container',
                  [
                    if (page.data.page['hideTitle'] != true)
                      div(
                        classes: 'content-header',
                        [
                          h1([.text(page.data.page['title'] as String? ?? '')]),
                          if (page.data.page['description'] != null) p([.text(page.data.page['description'] as String)]),
                        ],
                      ),
                    div(
                      classes: 'content-body',
                      [
                        child,
                      ],
                    ),
                  ],
                ),
              ]),
            ]),
          ],
        ),
      ],
    );
  }

  static List<StyleRule> get _styles => [
    css('.docs', [
      css('.header-container', [
        css('&').styles(
          position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero),
          zIndex: ZIndex(10),
          raw: {'backdrop-filter': 'blur(8px)'},
        ),
      ]),
      css('.main-container', [
        css('&').styles(
          padding: Padding.zero,
          margin: Margin.symmetric(horizontal: Unit.auto),
        ),
        css.media(MediaQuery.all(minWidth: 768.px), [
          css('&').styles(padding: Padding.symmetric(horizontal: 1.25.rem)),
        ]),
        css('main', [
          css('&').styles(
            position: Position.relative(),
            padding: Padding.only(top: 4.rem),
          ),
          css('> div', [
            css('&').styles(
              padding: Padding.only(top: 2.rem, left: 1.rem, right: 1.rem),
              display: Display.flex,
              justifyContent: JustifyContent.center,
            ),
            css('.content-container', [
              css('&').styles(
                flex: Flex(grow: 1, shrink: 1, basis: 0.percent),
                minWidth: Unit.zero,
                maxWidth: 80.rem,
                padding: Padding.only(right: Unit.zero),
              ),
              css.media(MediaQuery.all(minWidth: 1280.px), [css('&').styles(padding: Padding.only(right: 3.rem))]),
              css('.content-header', [
                css('&').styles(
                  margin: Margin.only(bottom: 2.rem),
                  color: ContentColors.headings,
                ),
                css('h1').styles(fontSize: 2.rem, lineHeight: 2.25.rem),
                css('p').styles(
                  fontSize: 1.25.rem,
                  lineHeight: 1.25.rem,
                  margin: Margin.only(top: .75.rem),
                ),
              ]),
            ]),
          ]),
        ]),
      ]),
    ]),
    css('.header-link').styles(
      padding: .symmetric(horizontal: 1.rem, vertical: 0.5.rem),
      textDecoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      color: Color.inherit,
      raw: {
        'border-bottom': '1.5px solid transparent',
        'transition': 'all 0.2s',
      },
    ),
    css('.header-link:hover').styles(
      color: ContentColors.primary,
      raw: {
        'border-bottom-color': 'currentColor',
      },
    ),
  ];
}

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
    ContentApp(
      // Enables mustache templating inside the markdown files.
      templateEngine: MustacheTemplateEngine(),
      eagerlyLoadAllPages: true,
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
          builder: (_, _, _) => Hero(),
        ),
        CustomComponent(
          pattern: 'BlogGrid',
          builder: (_, _, _) => BlogGrid(),
        ),
        // Adds zooming and caption support to images.
        Image(zoom: true),
      ],
      layouts: [
        BlogLayout(
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
  );
}
