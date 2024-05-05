// 데이터베이스 관련 코드를 작성합니다.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/store_menu.dart';

class ShoppingCartDatabase {
  static Database? _database;
  static final ShoppingCartDatabase instance = ShoppingCartDatabase._privateConstructor();

  ShoppingCartDatabase._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shopping_cart.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE selected_menus (
        id INTEGER PRIMARY KEY,
        menu_id TEXT,
        quantity INTEGER
      )
    ''');
  }

  Future<void> insertMenu(StoreMenu menu, int quantity) async {
    final db = await database;
    await db.insert(
      'selected_menus',
      {'menu_id': menu.id, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSelectedMenus() async {
    final db = await database;
    return await db.query('selected_menus');
  }

  Future<void> removeMenu(StoreMenu menu) async {
    final db = await database;
    await db.delete(
      'selected_menus',
      where: 'menu_id = ?',
      whereArgs: [menu.id],
    );
  }

  Future<StoreMenu?> getMenuById(String menuId) async {
    final db = await database;
    final maps = await db.query(
      'store_menus',
      where: 'id = ?',
      whereArgs: [menuId],
    );
    if (maps.isNotEmpty) {
      return StoreMenu.fromJson(menuId, maps.first);
    }
    return null;
  }
}
