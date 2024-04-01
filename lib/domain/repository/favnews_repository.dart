import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:pravda_news/domain/entity/fav_news.dart';

import '../../data/source/local/sqlite_storage.dart';

abstract class FavNewsRepository {
  Future<List<FavNews>> getFavNews();

  Future<int> deleteFavNews(int id);

  Future<int> addFavNews(NewsDto dto);
}

class FavNewsRepositoryImpl implements FavNewsRepository {
  DatabaseHelper databaseHelper;

  FavNewsRepositoryImpl(this.databaseHelper);

  @override
  Future<List<FavNews>> getFavNews() async {
    return (await databaseHelper.getAll())
        .map((e) => FavNews.fromMap(e))
        .toList();
  }

  @override
  Future<int> addFavNews(NewsDto dto) async {
    FavNews model = FavNews(
        id: dto.id,
        title: dto.title,
        description: dto.description,
        imageUrl: dto.imageUrl,
        date: dto.date,
        content: dto.content,
        url: dto.url,
        author: dto.author);
    return databaseHelper.insert(model);
  }

  @override
  Future<int> deleteFavNews(int id) async {
    return databaseHelper.deleteById(id);
  }
}
