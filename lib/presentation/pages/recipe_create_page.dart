import 'package:book_f_recipes/viewmodels/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/recipe.dart';

class CreateRecipePage extends StatefulWidget {
  final int categoryId;

  const CreateRecipePage({super.key, required this.categoryId});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    final String name = _nameController.text.trim();

    if (name.isEmpty) {
      // Показать сообщение об ошибке
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите название рецепта')));
      return;
    }

    // Создаем объект Recipe
    final Recipe newRecipe = Recipe(
      id: null, // id сгенерируется автоматически
      name: name,
      categoryId: widget.categoryId,
      description: "",
      prepareTime: 120,
    );

    final RecipeViewModel recipeViewModel = Provider.of<RecipeViewModel>(
      context,
      listen: false,
    );
    await recipeViewModel.addRecipe(newRecipe);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый рецепт')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Название рецепта'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
