import 'package:flutter/material.dart';
import 'package:pravda_news/services/get_news.dart';
import 'package:pravda_news/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'components/news_block.dart';
import 'logger/logger.dart';

class NewsLine extends StatefulWidget {
  const NewsLine({super.key});

  @override
  NewsLineState createState() => NewsLineState();
}

class NewsLineState extends State<NewsLine> {
  Future<List<News>> news = Future.value([]);
  late int currentPage;
  late ScrollController scrollController;
  bool loading = false;
  var _isDark = false;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
    scrollController = ScrollController();
    news = getNews(currentPage, news);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> pullRefresh() async {
    setState(() {
      news = getNews(currentPage, Future<List<News>>.value([]));
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
          news = getNews(currentPage, news);
        });
      }
    });

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            centerTitle: true,
            title: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'PravdaNews',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton(
                  onPressed: () {
                    final themeProvider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    setState(() {
                      _isDark = !_isDark;
                    }); // change the variable

                    _isDark
                        ? themeProvider.setDarkMode()
                        : themeProvider.setLightMode();
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
                          News ex = snapshot.data!.elementAt(index);
                          return NewsBlock(
                            title: ex.title,
                            description: ex.description,
                            date: ex.date,
                            imageUrl: ex.imageUrl,
                            content: ex.content,
                            url: ex.url,
                            author: ex.author,
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ));
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: Provider.of<ThemeProvider>(context).currentTheme,
        home: const NewsLine(),
      );
}

void main() {
  initLogger();
  logger.info('Start main');
  runApp(
    MultiProvider(
      // create the provider
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: const App(),
    ),
  );
}
