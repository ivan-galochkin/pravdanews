import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:pravda_news/domain/providers.dart';
import 'package:pravda_news/presentation/animation/animations.dart';

class NewsBlock extends ConsumerStatefulWidget {
  final NewsDto newsDto;

  const NewsBlock({super.key, required this.newsDto});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NewsBlockState();
}

class NewsBlockState extends ConsumerState<NewsBlock> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    isSaved =
        ref.read(memoryStorageProvider).idsMap[widget.newsDto.id] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(updateSavedBool, (previous, next) {
      setState(() {
        isSaved =
            ref.read(memoryStorageProvider).idsMap[widget.newsDto.id] ?? false;
      });
    });
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: InkWell(
        highlightColor: Colors.redAccent.withOpacity(0.2),
        splashColor: Colors.redAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(context, createRouteOpenNews(widget.newsDto));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.primaryContainer),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Hero(
                    tag: widget.newsDto.id,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: widget.newsDto.imageUrl == 'NoImage'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset('assets/img.png',
                                    fit: BoxFit.cover, height: 200))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  widget.newsDto.imageUrl,
                                  fit: BoxFit.cover,
                                  height: 200,
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
                                        width: 300,
                                        height: 200,
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
                              )))),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                widget.newsDto.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                widget.newsDto.description,
                maxLines: 4,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        style: Theme.of(context).textTheme.labelSmall,
                        ref
                            .read(utilsProvider)
                            .formatDate(widget.newsDto.date)),
                    isSaved
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isSaved = false;
                              });
                              ref
                                  .read(memoryStorageProvider)
                                  .deleteId(widget.newsDto.id);
                              ref
                                  .read(favNewsRepositoryProvider)
                                  .deleteFavNews(widget.newsDto.id);

                              ref.read(favNewsProvider.notifier).state = ref
                                  .read(favNewsRepositoryProvider)
                                  .getFavNews();
                            },
                            icon: const Icon(
                              Icons.bookmark_remove,
                              size: 30,
                            ))
                        : IconButton(
                            onPressed: () {
                              ref
                                  .read(memoryStorageProvider)
                                  .addId(widget.newsDto.id);
                              ref
                                  .read(favNewsRepositoryProvider)
                                  .addFavNews(widget.newsDto);
                              ref.read(favNewsProvider.notifier).state = ref
                                  .read(favNewsRepositoryProvider)
                                  .getFavNews();
                              setState(() {
                                isSaved = true;
                              });
                            },
                            icon: const Icon(
                              Icons.bookmark_add_outlined,
                              size: 30,
                            ))
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
