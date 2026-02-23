import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

import 'hero.dart';

class AppLayout extends PageLayoutBase {
  final Header? header;

  AppLayout({this.header});

  @override
  Pattern get name => RegExp('.*');

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page);
    yield link(rel: 'icon', type: 'image/png', href: '/favicon-32x32.png', attributes: {'sizes': '32x32'});
    yield link(rel: 'icon', type: 'image/png', href: '/favicon-16x16.png', attributes: {'sizes': '16x16'});
    yield link(rel: 'apple-touch-icon', href: '/apple-touch-icon.png', attributes: {'sizes': '180x180'});
    yield Style(styles: [..._styles, ...Hero.styles]);
  }

  @override
  Component buildBody(Page page, Component child) {
    var image = page.data.page['image'] as String?;
    if (image == null) {
      var path = page.path;
      if (!path.startsWith('/')) path = '/$path';
      if (path.length > 1 && path.endsWith('/')) {
        path = path.substring(0, path.length - 1);
      }
      if (path.endsWith('.md')) {
        path = path.substring(0, path.length - 3);
      }

      if (path == '/') {
        image = '/images/hero/index.png';
      } else if (path == '/about') {
        image = '/images/hero/about.png';
      } else if (path.startsWith('/blog/')) {
        var slug = page.data.page['slug'] as String?;
        var name = slug ?? path.substring(6);
        if (name.isNotEmpty) {
          image = '/images/hero/$name.png';
        }
      }
    }

    var path = page.path;
    if (!path.startsWith('/')) path = '/$path';
    var isBlogPost = path.startsWith('/blog/') && path != '/blog/' && path != '/blog/index' && path != '/blog/index.md';
    
    var date = page.data.page['date'];
    String? formattedDate;
    if (date != null) {
      if (date is DateTime) {
        formattedDate = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      } else {
        var dateStr = date.toString();
        try {
          var d = DateTime.parse(dateStr);
          formattedDate = '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
        } catch (_) {
          formattedDate = dateStr;
        }
      }
    }

    return div(
      classes: 'docs',
      [
        if (header != null)
          div(classes: 'header-container', [
            div(classes: 'header-content', [
              header!,
            ]),
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
                      Hero(
                        title: page.data.page['title'] as String?,
                        content: page.data.page['description'] as String?,
                        image: image,
                      ),
                    div(
                      classes: 'content-body',
                      [
                        child,
                        if (isBlogPost && formattedDate != null)
                          div(classes: 'content-date', [
                            Component.text('Published on $formattedDate'),
                          ]),
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
            css('.header-content').styles(
              maxWidth: 80.rem,
              margin: Margin.symmetric(horizontal: Unit.auto),
            ),
          ]),
          css('.main-container', [
            css('&').styles(
              margin: Margin.symmetric(horizontal: Unit.auto),
              padding: Padding.zero,
            ),
            css.media(MediaQuery.all(minWidth: 768.px), [
              css('&').styles(padding: Padding.symmetric(horizontal: 1.25.rem)),
            ]),
            css('main', [
              css('&').styles(
                padding: Padding.only(top: 4.rem, bottom: 8.rem),
                position: Position.relative(),
              ),
              css('> div', [
                css('&').styles(
                  display: Display.flex,
                  justifyContent: JustifyContent.center,
                  padding: Padding.only(top: 2.rem, left: 1.rem, right: 1.rem),
                ),
                css('.content-container', [
                  css('&').styles(
                    flex: Flex(grow: 1, shrink: 1, basis: 0.percent),
                    maxWidth: 80.rem,
                    minWidth: Unit.zero,
                    padding: Padding.only(right: Unit.zero),
                  ),
                  css.media(MediaQuery.all(minWidth: 80.rem), [css('&').styles(padding: Padding.only(right: 3.rem))]),
                  css('.content-header', [
                    css('&').styles(
                      color: ContentColors.headings,
                      margin: Margin.only(bottom: 2.rem),
                    ),
                    css('h1').styles(fontSize: 2.rem, lineHeight: 2.25.rem),
                    css('p').styles(
                      fontSize: 1.25.rem,
                      lineHeight: 1.25.rem,
                      margin: Margin.only(top: .75.rem),
                    ),
                  ]),
                  css('.content-body').styles(
                    maxWidth: 64.rem,
                    margin: Margin.symmetric(horizontal: Unit.auto),
                  ),
                  css('.content-date').styles(
                    margin: Margin.only(top: 4.rem),
                    padding: Padding.only(top: 1.rem),
                    raw: {
                      'border-top': '1px solid #eee',
                      'color': '#888',
                    },
                    fontSize: 0.9.rem,
                    textAlign: TextAlign.right,
                  ),
                ]),
              ]),
            ]),
          ]),
        ]),
        css('.header-link').styles(
          color: Color.inherit,
          fontWeight: FontWeight.w600,
          padding: .symmetric(horizontal: 1.rem, vertical: 0.5.rem),
          textDecoration: TextDecoration.none,
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
