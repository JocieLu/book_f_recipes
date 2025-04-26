import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '../../core/models/recipe_ingredients.dart';

class RecipeIngredientsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertRecipeIngredients(
    RecipeIngredients recipeIngredients,
  ) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'recipe_ingredients',
      recipeIngredients.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecipeIngredients>> getIngredientsByRecipeId(int recipeId) async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recipe_ingredients',
      where: 'recipeId = ?',
      whereArgs: <int>[recipeId],
    );

    return List<RecipeIngredients>.generate(
      maps.length,
      (int index) => RecipeIngredients.fromMap(maps[index]),
    );
  }

  Future<void> updateRecipeIngredients(
    RecipeIngredients recipeIngredients,
  ) async {
    final Database db = await _databaseHelper.database;
    await db.update(
      'recipe_ingredients',
      recipeIngredients.toMap(),
      where: 'id = ?',
      whereArgs: <int>[recipeIngredients.id!],
    );
  }

  Future<void> deleteRecipeIngredients(int id) async {
    final Database db = await _databaseHelper.database;
    await db.delete(
      'recipe_ingredients',
      where: 'id = ?',
      whereArgs: <int>[id],
    );
  }
}
