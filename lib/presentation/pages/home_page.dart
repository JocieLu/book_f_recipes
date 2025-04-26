import 'package:book_f_recipes/presentation/pages/recipe_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../core/models/category.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryViewModel categoryViewModel = Provider.of<CategoryViewModel>(
      context,
    );

    if (categoryViewModel.categories.isEmpty) {
      categoryViewModel.fetchCategories();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Категории')),
      body:
          categoryViewModel.categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: categoryViewModel.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final Category category = categoryViewModel.categories[index];
                  return ListTile(
                    title: Text(category.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<RecipeListPage>(
                          builder:
                              (BuildContext context) => RecipeListPage(
                                categoryId: category.id!,
                                categoryName: category.name,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
