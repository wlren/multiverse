import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiverse/repository/news_repository.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/news/news.dart';

class NewsArticleScreen extends StatelessWidget {
  const NewsArticleScreen(this.news, {Key? key}) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<NewsArticle>(
              future:
                  context.read<NewsRepository>().fetchArticle(news.newsPageUrl),
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Builder(
                    builder: (context) {
                      if (snapshot.hasData) {
                        final article = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(news.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                  if (article.subtitle != null) ...{
                                    const SizedBox(height: 16.0),
                                    Text(
                                      article.subtitle!,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  },
                                  const SizedBox(height: 16.0),
                                  Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(news.date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            color: Theme.of(context).hintColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            FadeInImage.memoryNetwork(
                              height: 256,
                              placeholder: kTransparentImage,
                              image: article.imageUrl,
                            ),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.imageCaption,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  const SizedBox(height: 32.0),
                                  for (var paragraph in article.paragraphs) ...{
                                    if (paragraph.isTitle)
                                      const SizedBox(height: 16.0),
                                    Text(
                                      paragraph.content,
                                      textAlign: paragraph.isTitle
                                          ? TextAlign.start
                                          : TextAlign.justify,
                                      style: paragraph.isTitle
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline6
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                    ),
                                    const SizedBox(height: 16.0),
                                  },
                                  const SizedBox(height: 24.0),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return _buildMockArticle(context);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockArticle(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).scaffoldBackgroundColor,
      highlightColor: Theme.of(context).highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Text(
                    'Random title',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.transparent),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  color: Colors.white,
                  child: Text(
                    'very long text',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.transparent),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  color: Colors.white,
                  child: Text(
                    'Random title that is long',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.transparent),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  color: Colors.white,
                  child: Text(
                    'Supposed date',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 256,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    'random text that is supposed to be the caption',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: Colors.transparent),
                  ),
                ),
                ..._buildMockParagraph(context),
                ..._buildMockParagraph(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMockParagraph(BuildContext context) {
    return [
      const SizedBox(height: 24.0),
      Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          'placeholder',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.transparent),
        ),
      ),
      const SizedBox(height: 8.0),
      Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          'placeholder',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.transparent),
        ),
      ),
      const SizedBox(height: 8.0),
      Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          'placeholder',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.transparent),
        ),
      ),
      const SizedBox(height: 8.0),
      Container(
        width: MediaQuery.of(context).size.width / 2,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Text(
          'placeholder',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.transparent),
        ),
      ),
    ];
  }
}
