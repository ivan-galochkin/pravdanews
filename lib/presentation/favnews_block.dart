import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravda_news/domain/providers.dart';

import '../domain/entity/fav_news.dart';
import 'news_page.dart';

class FavNewsBlock extends ConsumerStatefulWidget {
  final FavNews favNews;

  const FavNewsBlock({super.key, required this.favNews});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FavNewsBlockState();
}

class FavNewsBlockState extends ConsumerState<FavNewsBlock> {
  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          highlightColor: Colors.redAccent.withOpacity(0.2),
          splashColor: Colors.redAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewsPage(newsDto: widget.favNews.toNewsDto());
            }))
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Add padding around the row widget
              Padding(
                padding: const EdgeInsets.all(15),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add an image widget to display an image
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: widget.favNews.imageUrl == 'NoImage'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset('assets/img.png',
                                      fit: BoxFit.contain,
                                      height: 100,
                                      width: 100))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    widget.favNews.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    errorBuilder:
                                        (context, exception, stackTrace) {
                                      return Image.asset('assets/img.png',
                                          fit: BoxFit.contain,
                                          height: 100,
                                          width: 100);
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                          width: 100,
                                          height: 100,
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
                      // Add some spacing between the image and the text
                      Container(width: 20),
                      // Add an expanded widget to take up the remaining horizontal space
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.favNews.title,
                                maxLines: 3,
                                style: Theme.of(context).textTheme.titleSmall),
                            // Add some spacing between the subtitle and the text
                            Container(height: 10),
                            Text(
                                ref
                                    .read(utilsProvider)
                                    .formatDate(widget.favNews.date),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(fontWeight: FontWeight.w300))
                            // Add a text widget to display some text
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => {
                                    ref
                                        .read(memoryStorageProvider)
                                        .deleteId(widget.favNews.id),
                                    ref
                                        .read(favNewsRepositoryProvider)
                                        .deleteFavNews(widget.favNews.id),
                                    ref.read(favNewsProvider.notifier).state =
                                        ref
                                            .read(favNewsRepositoryProvider)
                                            .getFavNews(),
                                  },
                              icon: const Icon(Icons.delete_rounded))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
