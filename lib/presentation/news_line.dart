import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:pravda_news/domain/entity/fav_news.dart';

import '../domain/providers.dart';
import 'animation/animated_theme_button.dart';
import 'animation/animations.dart';
import 'news_block.dart';

class NewsLine extends ConsumerStatefulWidget {
  const NewsLine({super.key});

  @override
  NewsLineState createState() => NewsLineState();
}

class NewsLineState extends ConsumerState<NewsLine> {
  Future<List<NewsDto>> news = Future.value([]);
  late Future<List<FavNews>> favNews;
  late int currentPage;
  late ScrollController scrollController;
  late ScrollController listScrollController;
  late Map<int, bool> savedMap;

  bool loading = false;
  var _isDark = false;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
    scrollController = ScrollController();
    listScrollController = ScrollController();
    news = ref
        .read(apiProvider)
        .extendOldNews(currentPage, Future<List<NewsDto>>.value([]));
    favNews = ref.read(favNewsRepositoryProvider).getFavNews();
    favNews.then((value) => value.map((e) => e.id).toList().forEach((element) {
          ref.read(memoryStorageProvider).idsMap[element] = true;
        }));
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    listScrollController.dispose();
  }

  Future<void> pullRefresh() async {
    setState(() {
      news = ref
          .read(apiProvider)
          .extendOldNews(currentPage, Future<List<NewsDto>>.value([]));
      currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > nextPageTrigger && !loading) {
        setState(() {
          loading = true;
          currentPage++;
          news = ref.read(apiProvider).extendOldNews(currentPage, news);
        });
      }
    });

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.book),
                onPressed: () => Navigator.push(context, createRouteOpenFavs())
                    .then((value) => ref.read(updateSavedBool.notifier).state =
                        !ref.read(updateSavedBool.notifier).state)),
            centerTitle: true,
            title: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'PravdaNews',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              AnimationRotateWrapper(
                  callback: () {
                    setState(() {
                      _isDark = !_isDark;
                    }); // change the variable

                    _isDark
                        ? ref.read(themeProvider).setDarkMode()
                        : ref.read(themeProvider).setLightMode();
                  },
                  child: ImageIcon(
                    color: Theme.of(context)
                        .iconButtonTheme
                        .style
                        ?.foregroundColor
                        ?.resolve({MaterialState.pressed}),
                    const AssetImage('assets/star.png'),
                    size: 35,
                  ))
            ])),
        body: RefreshIndicator(
            onRefresh: pullRefresh,
            child: CustomScrollView(controller: scrollController, slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: SectionHeaderDelegate()),
              SliverToBoxAdapter(
                child: FutureBuilder(
                    future: news,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data!.length > (currentPage - 1) * 5) {
                          loading = false;
                        }
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            controller: listScrollController,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              NewsDto ex = snapshot.data!.elementAt(index);
                              return NewsBlock(newsDto: ex);
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              )
            ])));
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  SectionHeaderDelegate();

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
          child: TextField(
            decoration: const InputDecoration(hintText: 'Search news'),
            style: Theme.of(context).textTheme.displaySmall,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
          ),
        ));
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
