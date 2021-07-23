import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../model/news/news.dart';

class NewsRepository {
  static final DateFormat dateFormat = DateFormat('dd MMMM yyyy');
  static final DateFormat dateFormat1 = DateFormat('MMMM dd yyyy');
  static final DateFormat dateFormat2 = DateFormat('MMMM dd, yyyy');

  final Client client = Client();

  DateTime parseDate(String dateString) {
    try {
      return dateFormat.parse(dateString);
    } on FormatException {
      try {
        return dateFormat1.parse(dateString);
      } on FormatException {
        try {
          return dateFormat2.parse(dateString);
        } on FormatException {
          return DateTime.now();
        }
      }
    }
  }

  Future<List<News>> fetchNews() async {
    final news = <News>[];
    news.addAll(await _fetchAnnouncements());
    news.addAll(await _fetchPressReleases());
    news.sort((news1, news2) => -news1.date.compareTo(news2.date));
    return news;
  }

  // TODO: Fix this; sometimes it works, sometimes it gets blocked.
  Future<List<News>> _fetchAnnouncements() async {
    final news = <News>[];
    final response = await client.get(
        Uri.parse('https://uci.nus.edu.sg/oca/latest-news/announcements/'),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
        });
    final content = response.body;
    final items = parse(content)
        .querySelectorAll('article .vc_grid-item > .vc_grid-item-mini');
    for (var item in items) {
      // debugPrint(item.text);
      final title =
          item.querySelector('.vc_gitem-post-data-source-post_title')!.text;
      final date =
          item.querySelector('.vc_gitem-post-data-source-post_date')!.text;
      final url = item.querySelector('a')!.attributes['href']!.trim();
      final imageUrl = item.querySelector('img')!.attributes['src']!;
      news.add(News(
        newsPageUrl: url,
        date: parseDate(date),
        title: title,
        coverImageUrl: imageUrl,
        isArticle: false,
      ));
    }
    return news;
  }

  Future<List<News>> _fetchPressReleases() async {
    final news = <News>[];
    final response = await client
        .get(Uri.parse('https://news.nus.edu.sg/?h=1&t=Press%20Releases'));
    final content = response.body;
    final items =
        parse(content).querySelectorAll('.div_allheadlines .mm_listitem');
    for (var item in items) {
      final title = item.querySelector('.pp_bigheadlines_title a')!.text;
      final newsUrl = 'https:' +
          item.querySelector('.pp_bigheadlines_title a')!.attributes['href']!;
      final date = item.querySelector('.pp_bigheadlines_date')!;

      final dateString = (date.querySelector('.pp_date_day')!.text +
              ' ' +
              date.querySelector('.pp_date_month')!.text +
              ' ' +
              date.querySelector('.pp_date_year')!.text)
          .trim();

      final styleString =
          item.querySelector('.pp_bigheadlines_image')!.attributes['style']!;

      final imageUrl = 'https:' +
          (RegExp(r'^background-image:url' +
                  RegExp.escape('(') +
                  r'(.*)' +
                  RegExp.escape(')'))
              .firstMatch(styleString)!
              .group(1)
              .toString());
      news.add(News(
        coverImageUrl: imageUrl,
        title: title,
        date: parseDate(dateString),
        newsPageUrl: newsUrl,
        isArticle: true,
      ));
    }
    return news;
  }

  Future<List<Image>> fetchArticleImages(String articleUrl) async {
    final response = await client.get(Uri.parse(articleUrl));
    final content = response.body;
    final items = parse(content).querySelectorAll('article img');
    return items
        .map((imageElement) => Image.network(imageElement.attributes['src']!))
        .toList();
  }

  Future<NewsArticle> fetchArticle(String articleUrl) async {
    final response = await client.get(Uri.parse(articleUrl));
    final content = response.body;
    final html = parse(content);
    final mainContent = html.querySelector('.content_main_case')!;
    final title =
        mainContent.querySelector('.div_text_companyprofile h1')!.text;
    final subtitle = mainContent.querySelector('.subtitle_case')?.text;
    final gallery = mainContent.querySelector('.pp_gridcontainer_gallery')!;
    final imageUrl =
        'https:' + gallery.querySelector('img')!.attributes['src']!;
    final imageCaption = gallery.querySelector('.pp_gallery_description')!.text;
    final articleContent = mainContent.querySelector('.ppmodule_textblock')!;

    final paragraphs = articleContent.querySelectorAll('p').map((element) {
      if (element.querySelector('u') != null) {
        // Is a title
        return NewsParagraph(element.text, isTitle: true);
      } else {
        return NewsParagraph(element.text, isTitle: false);
      }
    }).toList();

    return NewsArticle(
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        imageCaption: imageCaption,
        paragraphs: paragraphs);
  }
}
