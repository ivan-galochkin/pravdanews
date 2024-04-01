import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:pravda_news/data/source/network/api.dart';

import 'api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  const String apikey = '9adc50a259174dea94ed7444e9c2b282';
  const String pageSize = '5';
  const String keywords =
      '(communism%20OR%20marxis%20OR%20Lenin%20OR%20leftist%20OR%20socialism)AND%20-Putin%20AND%20-Ukraine';
  const String searchString =
      'https://newsapi.org/v2/everything?q=$keywords&sortBy=publishedAt&searchIn=title,description&language=en&apiKey=';

  const testString =
      '{"articles": [{"author": "a", "title": "t", "description": "d", "url": "u", "urlToImage": "uti", "publishedAt": "pA", "content": "c"}]}';

  group('getNews tests', () {
    test('getNews extends previous news', () async {
      final client = MockClient();
      const int testPage = 1;
      when(client.get(Uri.parse(
              '$searchString$apikey&pageSize=$pageSize&page=$testPage')))
          .thenAnswer((_) async => http.Response(testString, 200));
      final NewsDto oldNews = NewsDto('a', 'b', 'c', 'd', 'e', 'f', 'g');
      final NewsDto testNewNews =
          NewsDto.fromJson(json.decode(testString)['articles'][0]);
      final Future<List<NewsDto>> testOldNews =
          Future<List<NewsDto>>.value([oldNews]);
      final extendedNews =
          await ApiImpl(client).extendOldNews(testPage, testOldNews);
      expect(extendedNews, [oldNews, testNewNews]);
    });
    test('getNews process error', () async {
      final client = MockClient();
      const int testPage = 1;
      when(client.get(Uri.parse(
              '$searchString$apikey&pageSize=$pageSize&page=$testPage')))
          .thenAnswer((_) async => http.Response('', 500));
      final NewsDto oldNews = NewsDto('a', 'b', 'c', 'd', 'e', 'f', 'g');
      final Future<List<NewsDto>> testOldNews =
          Future<List<NewsDto>>.value([oldNews]);

      final extendedNews =
          await ApiImpl(client).extendOldNews(testPage, testOldNews);
      expect(extendedNews, [oldNews]);
    });
  });
}
