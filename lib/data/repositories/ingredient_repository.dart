import 'package:sqflite/sqflite.dart';
import '../../core/models/ingredient.dart';
import '../../core/database/database_helper.dart';

class IngredientRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Создание нового ингредиента
  Future<void> insertIngredient(Ingredient ingredient) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'ingredient',
      ingredient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Получение всех ингредиентов
  Future<List<Ingredient>> getAllIngredients() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('ingredient');

    return List<Ingredient>.generate(maps.length, (int i) {
      return Ingredient.fromMap(maps[i]);
    });
  }

  // Получение ингредиента по id
  Future<Ingredient?> getIngredientById(int id) async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ingredient',
      where: 'id = ?',
      whereArgs: <int>[id],
    );

    if (maps.isNotEmpty) {
      return Ingredient.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Обновление ингредиента
  Future<void> updateIngredient(Ingredient ingredient) async {
    final Database db = await _databaseHelper.database;
    await db.update(
      'ingredient',
      ingredient.toMap(),
      where: 'id = ?',
      whereArgs: <int>[ingredient.id!],
    );
  }

  // Удаление ингредиента
  Future<void> deleteIngredient(int id) async {
    final Database db = await _databaseHelper.database;
    await db.delete('ingredient', where: 'id = ?', whereArgs: <int>[id]);
  }
}
