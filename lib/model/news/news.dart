class News {
  final String newsPageUrl;
  final String coverImageUrl;
  final DateTime date;
  final String title;

  const News({
    required this.newsPageUrl,
    required this.coverImageUrl,
    required this.date,
    required this.title,
  });
}

class NewsArticle {
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String imageCaption;
  final List<NewsParagraph> paragraphs;

  NewsArticle({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.imageCaption,
    required this.paragraphs,
  });
}

class NewsParagraph {
  const NewsParagraph(this.content, {required this.isTitle});
  final String content;
  final bool isTitle;
}
