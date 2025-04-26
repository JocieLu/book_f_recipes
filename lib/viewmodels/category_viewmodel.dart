import 'package:flutter/material.dart';
import '../data/repositories/category_repository.dart';
import '../core/models/category.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();

  List<Category> _categories = <Category>[];
  List<Category> get categories => _categories;

  // Получить все категории
  Future<void> fetchCategories() async {
    _categories = await _categoryRepository.getAllCategories();
    notifyListeners(); // Обновить UI после получения данных
  }
}
