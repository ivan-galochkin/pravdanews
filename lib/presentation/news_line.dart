import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:pravda_news/domain/entity/fav_news.dart';
import 'package:pravda_news/presentation/favnews_line.dart';

import '../domain/providers.dart';
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
  late Map<int, bool> savedMap;

  bool loading = false;
  var _isDark = false;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
    scrollController = ScrollController();
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.book),
                onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const FavNewsLine();
                    })).then((value) => ref
                        .read(updateSavedBool.notifier)
                        .state = !ref.read(updateSavedBool.notifier).state)),
            centerTitle: true,
            title: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'PravdaNews',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isDark = !_isDark;
                    }); // change the variable

                    _isDark
                        ? ref.read(themeProvider).setDarkMode()
                        : ref.read(themeProvider).setLightMode();
                  },
                  icon: const ImageIcon(
                    AssetImage('assets/star.png'),
                    size: 38,
                  )),
            ])),
        body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: Scrollbar(
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
                        controller: scrollController,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          NewsDto ex = snapshot.data!.elementAt(index);
                          return NewsBlock(newsDto: ex);
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ));
  }
}
