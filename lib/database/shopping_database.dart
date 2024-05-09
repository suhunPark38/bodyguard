import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/store_menu.dart';

class ShoppingDatabase {
  static Database? _database;
  static final ShoppingDatabase instance = ShoppingDatabase._privateConstructor();

  ShoppingDatabase._privateConstructor();

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
        store_id TEXT,
        menu_id TEXT,
        quantity INTEGER
      )
    ''');
  }

  Future<void> insertMenu(String storeId, String menuId, int quantity) async {
    final db = await database;
    await db.insert(
      'selected_menus',
      {'store_id': storeId, 'menu_id': menuId, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMenuQuantity(String menuId, int newQuantity) async {
    final db = await database;
    await db.update(
      'selected_menus',
      {'quantity': newQuantity},
      where: 'menu_id = ?',
      whereArgs: [menuId],
    );
  }


  Future<List<Map<String, dynamic>>> getSelectedMenus() async {
    final db = await database;
    return await db.query('selected_menus');
  }

  Future<void> removeMenu(String menuId) async {
    final db = await database;
    await db.delete(
      'selected_menus',
      where: 'menu_id = ?',
      whereArgs: [menuId],
    );
  }
  static Future<void> clearData() async {
    final db = await instance.database;
    await db.delete('selected_menus'); // 모든 데이터 삭제
  }
}
