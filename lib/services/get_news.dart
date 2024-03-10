import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pravda_news/logger/logger.dart';

const String apikey = '9adc50a259174dea94ed7444e9c2b282';
const String pageSize = '5';
const String keywords =
    '(communism%20OR%20marxis%20OR%20Lenin%20OR%20leftist%20OR%20socialism)AND%20-Putin%20AND%20-Ukraine';
const String searchString =
    'https://newsapi.org/v2/everything?q=$keywords&sortBy=publishedAt&searchIn=title,description&language=en&apiKey=';

Future<List<News>> getNews(int page, Future<List<News>> oldNews) async {
  Uri uri = Uri.parse('$searchString$apikey&pageSize=$pageSize&page=$page');

  final response = await http.get(uri);

  if (response.statusCode == 200 || response.statusCode == 201) {
    Map<String, dynamic> result = json.decode(response.body);
    List articles = result['articles'];
    List<News> news = articles.map((e) => News.fromJson(e)).toList();
    news = news.where((element) => element.title != '[Removed]').toList();
    (await oldNews).addAll(news);
    return oldNews;
  } else {
    logger.info('Error - ${response.statusCode}');
    return [];
  }
}

class News {
  String title, description, imageUrl, date, content, url, author;

  News(this.title, this.description, this.imageUrl, this.date, this.content,
      this.url, this.author);

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      json['title'] ?? 'No title',
      json['description'] ?? 'No description',
      json['urlToImage'] ?? 'NoImage',
      json['publishedAt'] ?? '',
      json['content'] ?? 'No content',
      json['url'] ?? '',
      json['author'] ?? 'Author unknown',
    );
  }
}
