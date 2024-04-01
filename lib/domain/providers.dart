import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pravda_news/data/source/local/sqlite_storage.dart';
import 'package:pravda_news/data/source/network/api.dart';
import 'package:pravda_news/domain/repository/favnews_repository.dart';
import 'package:pravda_news/domain/utils/utils.dart';

import '../theme/theme_provider.dart';
import 'entity/fav_news.dart';

final apiProvider = Provider<Api>((ref) => ApiImpl(http.Client()));

final themeProvider = ChangeNotifierProvider((ref) => ThemeNotifier());

final utilsProvider = Provider<Utils>((ref) => UtilsImpl());

final dbProvider = Provider<DatabaseHelper>((ref) => DatabaseHelperImpl());

final favNewsRepositoryProvider = Provider<FavNewsRepository>(
    (ref) => FavNewsRepositoryImpl(ref.read(dbProvider)));

final memoryStorageProvider =
    Provider<MemoryIdStorage>((ref) => MemoryIdStorage());

final favNewsProvider = StateProvider<Future<List<FavNews>>>((ref) {
  return ref.read(favNewsRepositoryProvider).getFavNews();
});

final updateSavedBool = StateProvider<bool>((ref) => false);
