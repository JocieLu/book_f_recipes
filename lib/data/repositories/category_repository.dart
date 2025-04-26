import 'package:sqflite/sqflite.dart';
import '../../core/models/category.dart';
import '../../core/database/database_helper.dart';

class CategoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Получение всех категорий
  Future<List<Category>> getAllCategories() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('category');

    return List<Category>.generate(maps.length, (int i) {
      return Category(id: maps[i]['id'], name: maps[i]['name']);
    });
  }

  // Добавление новой категории
  Future<void> insertCategory(Category category) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'category',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Обновление категории
  Future<void> updateCategory(Category category) async {
    final Database db = await _databaseHelper.database;
    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: <int>[category.id!],
    );
  }

  // Удаление категории
  Future<void> deleteCategory(int id) async {
    final Database db = await _databaseHelper.database;
    await db.delete('category', where: 'id = ?', whereArgs: <int>[id]);
  }
}
