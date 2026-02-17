import 'dart:io';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

class BlogGrid extends StatelessComponent {
  final String? title;

  const BlogGrid({this.title, super.key});

  @override
  Component build(BuildContext context) {
    // Read blog posts from filesystem during build
    final blogDir = Directory('content/blog');
    if (!blogDir.existsSync()) {
      return div([.text('Blog directory not found')]);
    }

    final posts = blogDir.listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.md') && !f.path.endsWith('index.md'))
        .map((f) => _parsePost(f))
        .toList();

    // Sort by date descending
    posts.sort((p1, p2) => p2.date.compareTo(p1.date));

    return div(
      classes: 'blog-grid',
      [
        if (title != null) h2([.text(title!)]),
        ul(
          classes: 'article-list',
          posts.map((post) => li(
            classes: 'article-entry',
            [
              a(
                href: post.url,
                classes: 'article-link',
                [
                  if (post.image != null)
                    img(src: post.image!, alt: post.title),
                  h2(classes: 'article-title', [.text(post.title)]),
                  div(classes: 'article-description', [p([.text(post.description)])]),
                ],
              ),
              div(
                classes: 'article-meta',
                [
                  small(classes: 'meta-date', [.text(post.date)]),
                  if (post.tags.isNotEmpty)
                    small(
                      classes: 'meta-tags',
                      post.tags.map((tag) => span(classes: 'tag', [.text(tag)])).toList(),
                    ),
                ],
              ),
            ],
          )).toList(),
        ),
      ],
    );
  }

  _PostData _parsePost(File file) {
    final content = file.readAsStringSync();
    final lines = content.split('\n');
    
    String title = '';
    String date = '';
    String description = '';
    String? slug;
    List<String> tags = [];
    String? image;

    if (lines.isNotEmpty && lines[0].trim() == '---') {
      int endIdx = lines.indexWhere((l) => l.trim() == '---', 1);
      if (endIdx != -1) {
        final frontmatter = lines.sublist(1, endIdx);
        for (var line in frontmatter) {
          if (line.startsWith('title:')) {
            title = line.substring(6).trim().replaceAll('"', '');
          } else if (line.startsWith('date:')) {
            date = line.substring(5).trim();
          } else if (line.startsWith('description:')) {
            description = line.substring(12).trim();
          } else if (line.startsWith('slug:')) {
            slug = line.substring(5).trim();
          } else if (line.startsWith('tags:')) {
            // Simple tag parsing for ["a", "b"] or [a, b]
            final tagsStr = line.substring(5).trim();
            tags = tagsStr
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((t) => t.trim().replaceAll('"', ''))
                .where((t) => t.isNotEmpty)
                .toList();
          } else if (line.startsWith('image:')) {
            image = line.substring(6).trim();
          }
        }
      }
    }

    // fallback to filename for title if empty
    if (title.isEmpty) {
      title = file.path.split('/').last.replaceAll('.md', '');
    }

    final fileName = file.path.split('/').last.replaceAll('.md', '');
    final url = '/blog/${slug ?? fileName}';

    if (image == null) {
      final heroImage = '/images/hero/${slug ?? fileName}.png';
      if (File('web$heroImage').existsSync()) {
        image = heroImage;
      }
    }

    // Format date from YYYY-MM-DD to dd.MM.YYYY
    String formattedDate = date;
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        formattedDate = '${parts[2]}.${parts[1]}.${parts[0]}';
      }
    } catch (_) {}

    return _PostData(title, formattedDate, description, tags, image, url);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-grid').styles(
      maxWidth: 80.rem,
      margin: .symmetric(horizontal: .auto, vertical: 2.rem),
      padding: .symmetric(horizontal: 2.rem),
    ),
    css('.blog-grid > h2').styles(
      fontSize: 2.5.rem,
      fontWeight: FontWeight.w800,
      margin: .only(bottom: 2.rem),
    ),
    css('.article-list').styles(
      display: Display.grid,
      listStyle: ListStyle.none,
      margin: .all(Unit.zero),
      padding: .all(Unit.zero),
      raw: {
        'grid-template-columns': 'repeat(auto-fit, minmax(360px, 1fr))',
        'gap': '2rem',
      },
    ),
    css('.article-entry').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      padding: .all(Unit.zero),
      raw: {
        'border': '1px solid rgba(0, 0, 0, 0.1)',
        'transition': 'transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out',
        'overflow': 'hidden',
        'background-color': 'var(--background)',
      },
    ),
    css('.article-entry:hover').styles(
      raw: {
        'transform': 'translateY(-4px)',
        'box-shadow': '0 10px 20px rgba(0,0,0,0.1)',
      },
    ),
    css('.article-link').styles(
      textDecoration: TextDecoration.none,
      color: Color.inherit,
      display: Display.block,
    ),
    css('.article-link:hover .article-title').styles(
      color: ContentColors.primary,
    ),
    css('.article-title').styles(
      fontSize: 1.5.rem,
      fontWeight: FontWeight.w700,
      margin: .all(Unit.zero),
      padding: .only(top: 1.5.rem, left: 1.5.rem, right: 1.5.rem, bottom: 0.5.rem),
      raw: {'line-height': '1.2'},
    ),
    css('.article-description').styles(
      fontSize: 1.rem,
      padding: .symmetric(horizontal: 1.5.rem),
      margin: .only(bottom: 1.5.rem),
      raw: {
        'color': '#666',
        'display': '-webkit-box',
        '-webkit-line-clamp': '3',
        '-webkit-box-orient': 'vertical',
        'overflow': 'hidden',
      },
    ),
    css('.article-meta').styles(
      display: Display.flex,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      fontSize: 0.875.rem,
      padding: .all(1.5.rem),
      raw: {
        'margin-top': 'auto',
        'border-top': '1px solid rgba(0, 0, 0, 0.05)',
        'color': '#888',
      },
    ),
    css('.tag').styles(
      padding: .symmetric(horizontal: 0.5.rem, vertical: 0.2.rem),
      radius: .circular(4.px),
      fontWeight: FontWeight.w600,
      raw: {
        'background-color': 'rgba(0, 0, 0, 0.05)',
        'margin-left': '0.5rem',
      },
    ),
    css('.article-entry img').styles(
      width: 100.percent,
      height: Unit.auto,
      raw: {
        'aspect-ratio': '16 / 9',
        'object-fit': 'cover',
        'display': 'block',
      },
    ),
  ];
}

class _PostData {
  final String title;
  final String date;
  final String description;
  final List<String> tags;
  final String? image;
  final String url;

  _PostData(this.title, this.date, this.description, this.tags, this.image, this.url);
}
