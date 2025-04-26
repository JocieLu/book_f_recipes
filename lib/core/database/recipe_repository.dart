import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/recipe.dart';

class RecipeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

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
