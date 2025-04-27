import 'package:flutter/foundation.dart';
import '../data/repositories/recipe_repository.dart';
import '../data/repositories/recipe_ingredients_repository.dart';
import '../data/repositories/ingredient_repository.dart';
import '../../core/models/recipe.dart';
import '../../core/models/recipe_ingredients.dart';
import '../../core/models/ingredient.dart';

// Вспомогательная модель
class RecipeIngredientFull {
  final RecipeIngredients recipeIngredient;
  final Ingredient ingredient;

  RecipeIngredientFull({
    required this.recipeIngredient,
    required this.ingredient,
  });
}

class RecipeViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository = RecipeRepository();
  final RecipeIngredientsRepository _recipeIngredientsRepository =
      RecipeIngredientsRepository();
  final IngredientRepository _ingredientRepository = IngredientRepository();

  List<Recipe> _recipes = <Recipe>[];
  List<Recipe> get recipes => _recipes;

  List<RecipeIngredientFull> _recipeIngredients = <RecipeIngredientFull>[];
  List<RecipeIngredientFull> get recipeIngredients => _recipeIngredients;

  Future<List<Ingredient>> fetchAllIngredients() async {
    return await _ingredientRepository.getAllIngredients();
  }

  Future<void> fetchRecipesByCategory(int categoryId) async {
    _recipes = await _recipeRepository.getRecipesByCategory(categoryId);
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _recipeRepository.insertRecipe(recipe);
    await fetchRecipesByCategory(recipe.categoryId);
  }

  Future<void> fetchRecipeIngredients(int recipeId) async {
    final List<RecipeIngredients> ingredientsRaw =
        await _recipeIngredientsRepository.getIngredientsByRecipeId(recipeId);

    final List<RecipeIngredientFull> fullIngredients = <RecipeIngredientFull>[];

    for (final RecipeIngredients ri in ingredientsRaw) {
      final Ingredient? ingredient = await _ingredientRepository
          .getIngredientById(ri.ingredientId);
      if (ingredient != null) {
        fullIngredients.add(
          RecipeIngredientFull(recipeIngredient: ri, ingredient: ingredient),
        );
      }
    }

    _recipeIngredients = fullIngredients;
    notifyListeners();
  }

  Future<void> addRecipeIngredient(RecipeIngredients recipeIngredient) async {
    await _recipeIngredientsRepository.insertRecipeIngredients(
      recipeIngredient,
    );
    await fetchRecipeIngredients(recipeIngredient.recipeId);
  }

  Future<void> updateRecipeIngredient(
    RecipeIngredients recipeIngredient,
  ) async {
    await _recipeIngredientsRepository.updateRecipeIngredients(
      recipeIngredient,
    );
    await fetchRecipeIngredients(recipeIngredient.recipeId);
  }

  Future<void> deleteRecipeIngredient(int id, int recipeId) async {
    await _recipeIngredientsRepository.deleteRecipeIngredients(id);
    await fetchRecipeIngredients(recipeId);
  }
}
