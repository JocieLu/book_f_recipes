import 'package:book_f_recipes/presentation/pages/recipe_create_page.dart';
import 'package:book_f_recipes/presentation/pages/recipe_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/recipe.dart';
import '../../viewmodels/recipe_viewmodel.dart';

class RecipeListPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const RecipeListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final RecipeViewModel recipeViewModel = Provider.of<RecipeViewModel>(
      context,
    );

    // Загружаем рецепты при открытии страницы
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recipeViewModel.fetchRecipesByCategory(categoryId);
    });

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body:
          recipeViewModel.recipes.isEmpty
              ? const Center(child: Text('Нет рецептов'))
              : ListView.builder(
                itemCount: recipeViewModel.recipes.length,
                itemBuilder: (BuildContext context, int index) {
                  final Recipe recipe = recipeViewModel.recipes[index];
                  return ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => RecipeViewPage(recipeId: recipe.id!),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<RecipeCreatePage>(
                            builder:
                                (BuildContext context) => RecipeCreatePage(
                                  categoryId: recipe.categoryId,
                                  recipeId: recipe.id,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<RecipeCreatePage>(
              builder:
                  (BuildContext context) =>
                      RecipeCreatePage(categoryId: categoryId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
