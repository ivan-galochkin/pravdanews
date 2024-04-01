import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:pravda_news/domain/logger/logger.dart';

abstract class Api {
  Future<List<NewsDto>> extendOldNews(int page, Future<List<NewsDto>> oldNews);
}

class ApiImpl implements Api {
  static const String apikey = '9adc50a259174dea94ed7444e9c2b282';
  static const String pageSize = '5';
  static const String keywords =
      '(communism%20OR%20marxis%20OR%20Lenin%20OR%20leftist%20OR%20socialism)AND%20-Putin%20AND%20-Ukraine';
  static const String searchString =
      'https://newsapi.org/v2/everything?q=$keywords&sortBy=publishedAt&searchIn=title,description&language=en&apiKey=';

  http.Client client;

  ApiImpl(this.client);

  @override
  Future<List<NewsDto>> extendOldNews(
      int page, Future<List<NewsDto>> oldNews) async {
    Uri uri = Uri.parse('$searchString$apikey&pageSize=$pageSize&page=$page');

    final response = await client.get(uri);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> result = json.decode(response.body);
      List articles = result['articles'];
      List<NewsDto> news = articles.map((e) => NewsDto.fromJson(e)).toList();
      news = news.where((element) => element.title != '[Removed]').toList();
      (await oldNews).addAll(news);
      return oldNews;
    } else {
      logger.info('Error - ${response.statusCode}');
      return oldNews;
    }
  }
}
