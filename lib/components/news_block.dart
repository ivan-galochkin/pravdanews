import 'package:flutter/material.dart';
import '../pages/news_page.dart';
import '../services/utils.dart';

class NewsBlock extends StatefulWidget {
  final String title, description, imageUrl, date, content, url, author;

  const NewsBlock(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.imageUrl,
      required this.content,
      required this.url,
      required this.author});

  @override
  State<StatefulWidget> createState() => NewsBlockState();
}

class NewsBlockState extends State<NewsBlock> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: InkWell(
        highlightColor: Colors.redAccent.withOpacity(0.2),
        splashColor: Colors.redAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewsPage(
                title: widget.title,
                description: widget.description,
                date: widget.date,
                imageUrl: widget.imageUrl,
                content: widget.content,
                url: widget.url,
                author: widget.author);
          }));
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
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: widget.imageUrl == 'NoImage'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset('assets/img.png',
                                fit: BoxFit.cover, height: 200))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              height: 200,
                              errorBuilder: (context, exception, stackTrace) {
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
                          ))),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                widget.description,
                maxLines: 4,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Text(
                    style: Theme.of(context).textTheme.labelSmall,
                    formatDate(widget.date)))
          ]),
        ),
      ),
    );
  }
}
