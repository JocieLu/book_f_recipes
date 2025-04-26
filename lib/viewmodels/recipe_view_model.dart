import 'package:flutter/foundation.dart';
import '../data/repositories/recipe_repository.dart';
import '../../core/models/recipe.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository = RecipeRepository();

  List<Recipe> _recipes = <Recipe>[];
  List<Recipe> get recipes => _recipes;

  Future<void> fetchRecipesByCategory(int categoryId) async {
    _recipes = await _recipeRepository.getRecipesByCategory(categoryId);
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _recipeRepository.insertRecipe(recipe);
    await fetchRecipesByCategory(recipe.categoryId); // Перезагружаем список
  }
}
