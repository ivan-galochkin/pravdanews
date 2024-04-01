import 'package:pravda_news/data/dto/news_dto.dart';

class FavNews {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String content;
  final String url;
  final String author;

  FavNews(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.date,
      required this.content,
      required this.url,
      required this.author});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date,
      'content': content,
      'author': author,
      'url': url
    };
  }

  factory FavNews.fromMap(Map<String, dynamic> map) {
    return FavNews(
      id: map['id'],
      title: map['title'] ?? 'No title',
      description: map['description'] ?? 'No description',
      imageUrl: map['imageUrl'] ?? 'NoImage',
      date: map['date'] ?? '',
      content: map['content'] ?? 'No content',
      url: map['url'] ?? '',
      author: map['author'] ?? 'Author unknown',
    );
  }

  NewsDto toNewsDto() {
    return NewsDto(title, description, imageUrl, date, content, url, author);
  }
}
