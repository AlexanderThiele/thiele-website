import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Hero extends StatelessComponent {
  const Hero({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'hero',
      [
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
      padding: .only(bottom: 2.rem),
      position: Position.relative(),
      raw: {'align-items': 'flex-end'},
    ),
    css('.hero-details').styles(
      maxWidth: 44.rem,
      padding: .only(top: 3.rem, left: 2.rem, right: 2.rem),
      width: 85.percent,
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
