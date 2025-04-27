import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '../../core/models/recipe.dart';

class RecipeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<Recipe?> getRecipeByID(int id) async {
    final Database db = await _databaseHelper.database;
    Recipe? recipe;

    final List<Map<String, dynamic>> maps = await db.query(
      'recipe',
      where: 'id = ?',
      whereArgs: <int>[id],
    );

    Map<String, dynamic>? map = maps.firstOrNull;
    if (map != null) {
      recipe = Recipe.fromMap(map);
    }
    return recipe;
  }

  // Получение всех рецептов по id категории
  Future<List<Recipe>> getRecipesByCategory(int categoryId) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'recipe',
      where: 'categoryId = ?',
      whereArgs: <int>[categoryId],
    );

    return List<Recipe>.generate(maps.length, (int i) {
      return Recipe.fromMap(maps[i]);
    });
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final Database db = await _databaseHelper.database;
    await db.insert('recipe', recipe.toMap());
  }

  Future<void> deleteRecipe(int id) async {
    final Database db = await _databaseHelper.database;
    await db.delete('recipe', where: 'id = ?', whereArgs: <int>[id]);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final Database db = await _databaseHelper.database;
    await db.update(
      'recipe',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: <int>[recipe.id!],
    );
  }
}
