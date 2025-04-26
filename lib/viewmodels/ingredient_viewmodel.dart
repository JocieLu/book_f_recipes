import 'package:flutter/material.dart';
import '../../data/repositories/ingredient_repository.dart';
import '../../core/models/ingredient.dart';

class IngredientViewModel extends ChangeNotifier {
  final IngredientRepository _ingredientRepository = IngredientRepository();
  List<Ingredient> _ingredients = <Ingredient>[];

  List<Ingredient> get ingredients => _ingredients;

  // Получить все ингредиенты
  Future<void> fetchIngredients() async {
    _ingredients = await _ingredientRepository.getAllIngredients();
    notifyListeners();
  }

  // Добавить новый ингредиент
  Future<void> addIngredient(Ingredient ingredient) async {
    await _ingredientRepository.insertIngredient(ingredient);
    await fetchIngredients(); // Обновить список после добавления
  }

  // Обновить ингредиент
  Future<void> updateIngredient(Ingredient ingredient) async {
    await _ingredientRepository.updateIngredient(ingredient);
    await fetchIngredients(); // Обновить список после обновления
  }

  // Удалить ингредиент
  Future<void> deleteIngredient(int id) async {
    await _ingredientRepository.deleteIngredient(id);
    await fetchIngredients(); // Обновить список после удаления
  }
}
