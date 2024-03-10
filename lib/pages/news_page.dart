import 'package:pravda_news/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme_provider.dart';

class NewsPage extends StatefulWidget {
  final String title, description, imageUrl, date, content, url, author;

  const NewsPage(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.imageUrl,
      required this.content,
      required this.url,
      required this.author});

  @override
  State<StatefulWidget> createState() {
    return NewsPageState();
  }
}

class NewsPageState extends State<NewsPage> {
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
                      Text(widget.title,
                          style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.author,
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(formatDate(widget.date),
                              style: Theme.of(context).textTheme.labelMedium)
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              height: 250,
                              errorBuilder: (context, exception, stackTrace) {
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
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: Text(widget.description,
                              style: Theme.of(context).textTheme.bodyMedium)),
                      Text(
                        getContent(widget.content),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextButton(
                              onPressed: () =>
                                  {launchUrl(Uri.parse(widget.url))},
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
    );
  }
}
