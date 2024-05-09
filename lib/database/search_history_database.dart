import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SearchHistoryDatabase {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'search_history_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE search_history(id INTEGER PRIMARY KEY, search TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertSearch(String search) async {
    final Database db = await database;
    await db.insert(
      'search_history',
      {'search': search},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getSearchHistory() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('search_history');
    return List.generate(maps.length, (i) {
      return maps[i]['search'];
    });
  }

  Future<void> deleteSearch(String search) async {
    final Database db = await database;
    await db.delete(
      'search_history',
      where: "search = ?",
      whereArgs: [search],
    );
  }

  Future<void> clearAllSearches() async {
    final Database db = await database;
    await db.delete('search_history');
  }
}
