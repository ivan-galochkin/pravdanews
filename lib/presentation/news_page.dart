import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/providers.dart';
import 'animation/animated_theme_button.dart';

class NewsPage extends ConsumerStatefulWidget {
  final NewsDto newsDto;

  const NewsPage({super.key, required this.newsDto});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return NewsPageState();
  }
}

class NewsPageState extends ConsumerState<NewsPage> {
  var _isDark = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(widget.newsDto.title,
                          style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.newsDto.author,
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(
                              ref
                                  .read(utilsProvider)
                                  .formatDate(widget.newsDto.date),
                              style: Theme.of(context).textTheme.labelMedium)
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Hero(
                              tag: widget.newsDto.id,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  widget.newsDto.imageUrl,
                                  fit: BoxFit.cover,
                                  height: 250,
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return Image.asset('assets/img.png',
                                        fit: BoxFit.cover, height: 200);
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                        width: size.width,
                                        height: 300,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ));
                                  },
                                ),
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: Text(widget.newsDto.description,
                              style: Theme.of(context).textTheme.bodyMedium)),
                      Text(
                        ref
                            .read(utilsProvider)
                            .getContent(widget.newsDto.content),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextButton(
                              onPressed: () =>
                                  {launchUrl(Uri.parse(widget.newsDto.url))},
                              child: Text('more',
                                  style:
                                      Theme.of(context).textTheme.bodyLarge)))
                    ]),
              ))),
      appBar: AppBar(
          leading: IconButton(
            icon: const ImageIcon(AssetImage('assets/hammer.png'), size: 36),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Trust, but verify',
                style: Theme.of(context).textTheme.headlineLarge),
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
    );
  }
}
