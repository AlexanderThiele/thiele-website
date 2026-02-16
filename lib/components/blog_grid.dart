import 'dart:io';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class BlogGrid extends StatelessComponent {
  const BlogGrid({super.key});

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
        h2([.text('Latest Blog Posts')]),
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
                ],
              ),
              div([p([.text(post.description)])]),
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

    final url = '/blog/${file.path.split('/').last.replaceAll('.md', '')}';

    return _PostData(title, date, description, tags, image, url);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog-grid').styles(
      maxWidth: 64.rem,
      margin: .symmetric(horizontal: .auto, vertical: 2.rem),
      padding: .symmetric(horizontal: 2.rem),
    ),
    css('.article-list').styles(
      display: Display.grid,
      listStyle: ListStyle.none,
      margin: .all(Unit.zero),
      padding: .all(Unit.zero),
      raw: {
        'grid-template-columns': 'repeat(auto-fit, minmax(420px, 1fr))',
        'gap': '3rem',
      },
    ),
    css('.article-entry').styles(
      padding: .all(1.rem),
      display: Display.flex,
      flexDirection: FlexDirection.column,
      raw: {
        'border': '1px solid rgba(0, 0, 0, 0.2)',
      },
    ),
    css('.article-link').styles(
      textDecoration: TextDecoration.none,
      color: Color.inherit,
    ),
    css('.article-link:hover .article-title').styles(
      raw: {'text-decoration': 'underline'},
    ),
    css('.article-title').styles(
      fontSize: 1.5.rem,
      margin: .only(top: 1.rem, bottom: 0.5.rem),
    ),
    css('.article-meta').styles(
      display: Display.flex,
      justifyContent: JustifyContent.spaceBetween,
      fontSize: 0.875.rem,
      raw: {
        'margin-top': 'auto',
        'color': '#666',
      },
    ),
    css('.tag').styles(
      padding: .symmetric(horizontal: 0.5.rem, vertical: 0.2.rem),
      radius: .circular(4.px),
      raw: {
        'background-color': '#eee',
        'margin-left': '0.5rem',
      },
    ),
    css('.article-entry img').styles(
      width: 100.percent,
      height: Unit.auto,
      raw: {
        'aspect-ratio': '2 / 1',
        'object-fit': 'cover',
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
