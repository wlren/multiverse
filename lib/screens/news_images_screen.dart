import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/news/news.dart';
import '../repository/news_repository.dart';

class NewsImagesScreen extends StatelessWidget {
  const NewsImagesScreen(this.news, {Key? key}) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(news.title),
        ),
        body: FutureBuilder<List<Image>>(
          future: context
              .read<NewsRepository>()
              .fetchArticleImages(news.newsPageUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final images = snapshot.data!;
              return CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (context, position, index) {
                  return images[position];
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
