import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Hero extends StatelessComponent {
  final String? title;
  final String? content;
  final String? image;

  const Hero({this.title, this.content, this.image, super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'hero',
      [
        div(classes: 'hero-image-container', [
          img(classes: 'hero-image', src: image ?? '/images/hero.png', alt: 'Alexander Thiele'),
        ]),
        div(classes: 'hero-details', [
          h1(classes: 'hero-title', [.text(title ?? 'Alexander Thiele')]),
          p(classes: 'hero-content', [
            .text(
              content ??
                  'Techi 👨‍💻 Startup Enthusiast, Entrepreneur, Co-Founder. Creating Company & Engineering Culture & Flutter fan 🤓',
            ),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero').styles(
      position: Position.relative(),
      display: Display.flex,
      maxWidth: 80.rem,
      minHeight: 200.px,
      margin: .only(left: .auto, right: .auto, bottom: 4.rem),
      raw: {'align-items': 'flex-end'},
    ),
    css('.hero-image-container').styles(
      position: Position.relative(),
      width: 100.percent,
      raw: {
        'height': '61.8vh',
        'max-height': '560px',
      },
    ),
    css.media(MediaQuery.all(minWidth: 1024.px), [
      css('.hero-image-container').styles(
        width: 85.percent,
        margin: .only(left: .auto),
      ),
      css('.hero-details').styles(
        raw: {
          'left': '2.5rem',
        },
      ),
    ]),
    css('.hero-image-container::after').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'top': '0',
        'left': '0',
        'width': '100%',
        'height': '100%',
        'background': 'linear-gradient(180deg, rgba(0,47,75,0.5) 0, rgba(220,66,37,0.5))',
      },
    ),
    css('.hero-image').styles(
      width: 100.percent,
      height: 100.percent,
      margin: Margin.zero,
      raw: {
        'object-fit': 'cover',
      },
    ),
    css('.hero-details').styles(
      position: Position.absolute(),
      width: 85.percent,
      maxWidth: 44.rem,
      padding: .only(top: 3.rem, left: 2.rem, right: 2.rem),
      margin: Margin.zero,
      raw: {
        'background': 'var(--background)',
        'bottom': '0',
        'left': '0',
      },
    ),
    css('.hero-title').styles(
      margin: .only(bottom: 1.25.rem),
      fontSize: 2.rem,
      fontWeight: FontWeight.w800,
      letterSpacing: (-0.012).em,
      raw: {'line-height': '1.1'},
    ),
    css.media(MediaQuery.all(minWidth: 768.px), [
      css('.hero-title').styles(
        fontSize: 3.rem,
      ),
    ]),
    css('.hero-content').styles(
      margin: .all(Unit.zero),
      fontSize: 1.5.rem,
      fontWeight: FontWeight.w600,
    ),
  ];
}
