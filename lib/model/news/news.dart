import 'package:flutter/material.dart';

class News {
  final String newsPageUrl;
  final Image coverImage;
  final String postDate;
  final String title;

  const News({
    required this.newsPageUrl,
    required this.coverImage,
    required this.postDate,
    required this.title,
  });
}
