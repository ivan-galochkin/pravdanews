import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pravda_news/domain/entity/fav_news.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseHelper {
  Future<int> insert(FavNews model);

  Future<int> deleteById(int id);

  Future<List<Map<String, Object?>>> getById(int id);

  Future<List<Map<String, Object?>>> getAll();
}

class DatabaseHelperImpl implements DatabaseHelper {
  static final DatabaseHelperImpl _instance = DatabaseHelperImpl.internal();

  factory DatabaseHelperImpl() => _instance;

  static Database? _db;

  Future<Database> get db async {
    _db ??= await init();
    return _db!;
  }

  DatabaseHelperImpl.internal();

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main.db');
    return openDatabase(path, version: 1, onCreate: onCreate);
  }

  static const String tableName = 'fav_news';

  void onCreate(Database db, int flag) async => await db.execute(
      'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY NOT NULL,title STRING,description STRING,imageUrl STRING,date STRING,content STRING,url STRING,author STRING)');

  @override
  Future<List<Map<String, Object?>>> getById(int id) async =>
      (await db).rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);

  @override
  Future<List<Map<String, Object?>>> getAll() async =>
      (await db).rawQuery('SELECT * FROM $tableName');

  @override
  Future<int> insert(FavNews model) async =>
      (await db).insert(tableName, model.toMap());

  @override
  Future<int> deleteById(int id) async =>
      await (await db).delete(tableName, where: 'id = ?', whereArgs: [id]);
}
