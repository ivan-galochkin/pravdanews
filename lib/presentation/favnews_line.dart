import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravda_news/domain/entity/fav_news.dart';
import 'package:pravda_news/presentation/favnews_block.dart';

import '../domain/providers.dart';

class FavNewsLine extends ConsumerStatefulWidget {
  const FavNewsLine({super.key});

  @override
  FavNewsLineState createState() => FavNewsLineState();
}

class FavNewsLineState extends ConsumerState<FavNewsLine> {
  late Future<List<FavNews>> favNews;
  var _isDark = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            leading: IconButton(
                icon:
                    const ImageIcon(AssetImage('assets/hammer.png'), size: 36),
                onPressed: () => Navigator.of(context).pop()),
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
        body: Scrollbar(
          child: FutureBuilder(
              future: ref.watch(favNewsProvider),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        FavNews fn = snapshot.data!.elementAt(index);
                        return FavNewsBlock(favNews: fn);
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
