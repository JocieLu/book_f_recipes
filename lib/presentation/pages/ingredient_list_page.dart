import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/ingredient.dart';
import '../../viewmodels/ingredient_viewmodel.dart';
import 'create_ingredient_page.dart'; // Страница для создания ингредиента

class IngredientListPage extends StatefulWidget {
  const IngredientListPage({super.key});

  @override
  State<IngredientListPage> createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {
  late IngredientViewModel _ingredientViewModel;

  @override
  void initState() {
    super.initState();
    _ingredientViewModel = Provider.of<IngredientViewModel>(
      context,
      listen: false,
    );
    _ingredientViewModel
        .fetchIngredients(); // Загружаем ингредиенты через ViewModel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ингредиенты')),
      body: Consumer<IngredientViewModel>(
        builder: (
          BuildContext context,
          IngredientViewModel viewModel,
          Widget? child,
        ) {
          final List<Ingredient> ingredients = viewModel.ingredients;

          if (ingredients.isEmpty) {
            return const Center(child: Text('Ингредиенты отсутствуют'));
          }

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              final Ingredient ingredient = ingredients[index];
              return ListTile(
                title: Text(ingredient.name),
                subtitle: Text('Ед. изм: ${ingredient.unit}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const CreateIngredientPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
