import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

class AppLayout extends PageLayoutBase {
  final Header? header;

  AppLayout({this.header});

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
              margin: Margin.symmetric(horizontal: Unit.auto),
              padding: Padding.zero,
            ),
            css.media(MediaQuery.all(minWidth: 768.px), [
              css('&').styles(padding: Padding.symmetric(horizontal: 1.25.rem)),
            ]),
            css('main', [
              css('&').styles(
                padding: Padding.only(top: 4.rem),
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
                    maxWidth: 64.rem,
                    minWidth: Unit.zero,
                    padding: Padding.only(right: Unit.zero),
                  ),
                  css.media(MediaQuery.all(minWidth: 1280.px), [css('&').styles(padding: Padding.only(right: 3.rem))]),
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
