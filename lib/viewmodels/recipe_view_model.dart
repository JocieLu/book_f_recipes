import 'package:flutter/foundation.dart';
import '../../core/database/recipe_repository.dart';
import '../../core/models/recipe.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository = RecipeRepository();

  List<Recipe> _recipes = <Recipe>[];
  List<Recipe> get recipes => _recipes;

  Future<void> fetchRecipesByCategory(int categoryId) async {
    _recipes = await _recipeRepository.getRecipesByCategory(categoryId);
    notifyListeners();
  }
}
