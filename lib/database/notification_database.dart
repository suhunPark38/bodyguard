import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationDatabase {
  static final NotificationDatabase _instance = NotificationDatabase._internal();
  factory NotificationDatabase() => _instance;
  static Database? _database;

  NotificationDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'settings.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE settings(id INTEGER PRIMARY KEY, notificationsEnabled INTEGER)',
        );
      },
    );
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    final db = await database;
    await db.insert(
      'settings',
      {'id': 1, 'notificationsEnabled': enabled ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isNotificationEnabled() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('settings', where: 'id = ?', whereArgs: [1]);
    if (maps.isNotEmpty) {
      return maps.first['notificationsEnabled'] == 1;
    }
    return true; // 기본값: 알림 활성화
  }
}
