class Article {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String imageUrl;
  final String category;
  final String author;
  final DateTime date;
  final String url;

  Article({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.date,
    required this.url,
  });

  factory Article.fromWpJson(Map<String, dynamic> json) {
    final embedded = json['_embedded'] as Map<String, dynamic>?;

    String imageUrl = '';
    if (embedded != null && embedded['wp:featuredmedia'] != null) {
      final media = (embedded['wp:featuredmedia'] as List);
      if (media.isNotEmpty) {
        imageUrl = media[0]['source_url'] ?? '';
      }
    }

    String category = '';
    if (embedded != null && embedded['wp:term'] != null) {
      final terms = (embedded['wp:term'] as List);
      if (terms.isNotEmpty && (terms[0] as List).isNotEmpty) {
        category = terms[0][0]['name'] ?? '';
      }
    }

    String author = '';
    if (embedded != null && embedded['author'] != null) {
      final authors = (embedded['author'] as List);
      if (authors.isNotEmpty) {
        author = authors[0]['name'] ?? '';
      }
    }

    return Article(
      id: json['id'] ?? 0,
      title: _stripHtml(json['title']?['rendered'] ?? ''),
      excerpt: _stripHtml(json['excerpt']?['rendered'] ?? ''),
      content: json['content']?['rendered'] ?? '',
      imageUrl: imageUrl,
      category: category,
      author: author,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      url: json['link'] ?? '',
    );
  }

  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&hellip;', '...')
        .replaceAll('&amp;', '&')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#8230;', '...')
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .trim();
  }
}
