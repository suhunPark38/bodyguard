import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'activity_database.db';
  static const String tableSteps = 'steps';
  static const String colId = 'id';
  static const String colSteps = 'steps';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  static Future<Database> initializeDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''CREATE TABLE $tableSteps (
              $colId INTEGER PRIMARY KEY AUTOINCREMENT,
              $colSteps INTEGER
            )''',
        );
      },
    );
  }

  static Future<void> insertSteps(int steps) async {
    final Database db = await database;
    await db.insert(
      tableSteps,
      {colSteps: steps},
      /*conflictAlgorithm: ConflictAlgorithm.replace,*/
    );
  }

  static Future<int?> getSteps() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableSteps);
    if (maps.isNotEmpty) {
      return maps.first[colSteps] as int?;
    }
    return null;
  }
}
