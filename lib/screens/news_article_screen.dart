import 'package:flutter/material.dart';

import '../model/news/news.dart';

class NewsArticleScreen extends StatelessWidget {
  const NewsArticleScreen(this.news, {Key? key}) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(news.title, style: Theme.of(context).textTheme.headline5),
          // FutureBuilder<List<Image>>(
          //   future: context
          //       .read<NewsRepository>()
          //       .fetchArticleImages(news.newsPageUrl),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return CarouselSlider(
          //         items: [
          //           for (var item in snapshot.data!) ...{item}
          //         ],
          //         options: CarouselOptions(height: 100),
          //       );
          //       // return snapshot.data!.first;
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
