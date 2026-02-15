import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'hero',
      [
        div(classes: 'hero-image-container', [
          img(classes: 'hero-image', src: '/images/hero.png', alt: 'Alexander Thiele'),
        ]),
        div(classes: 'hero-details', [
          h1(classes: 'hero-title', [.text('Alexander Thiele')]),
          p(classes: 'hero-content', [.text('Techi 👨‍💻 Startup Enthusiast, Entrepreneur, Co-Founder. Creating Company & Engineering Culture & Flutter fan 🤓')]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero').styles(
      display: Display.flex,
      maxWidth: 80.rem,
      margin: .symmetric(horizontal: .auto),
      minHeight: 200.px,
      position: Position.relative(),
      raw: {'align-items': 'flex-end'},
    ),
    css('.hero-image-container').styles(
      width: 100.percent,
      position: Position.relative(),
      raw: {
        'height': '61.8vh',
        'max-height': '560px',
      },
    ),
    css.media(MediaQuery.all(minWidth: 1024.px), [
      css('.hero-image-container').styles(
        margin: .only(left: .auto),
        width: 85.percent,
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
      maxWidth: 44.rem,
      padding: .only(top: 3.rem, left: 2.rem, right: 2.rem),
      width: 85.percent,
      position: Position.absolute(),
      raw: {
        'background': 'var(--background)',
        'bottom': '0',
        'left': '0',
      },
    ),
    css('.hero-title').styles(
      fontSize: 3.rem,
      fontWeight: FontWeight.w800,
      margin: .only(bottom: 1.rem),
    ),
    css('.hero-content').styles(
      fontSize: 1.5.rem,
      fontWeight: FontWeight.w600,
      margin: .all(Unit.zero),
    ),
  ];
}
