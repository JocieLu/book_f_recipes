import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/recipe.dart';
import '../../viewmodels/recipe_viewmodel.dart';

class RecipeViewPage extends StatefulWidget {
  final int recipeId;

  const RecipeViewPage({super.key, required this.recipeId});

  @override
  State<RecipeViewPage> createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  late RecipeViewModel _recipeViewModel;
  Recipe? _recipe;
  List<RecipeIngredientFull> _ingredients = <RecipeIngredientFull>[];

  @override
  void initState() {
    super.initState();
    _recipeViewModel = Provider.of<RecipeViewModel>(context, listen: false);
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    await _recipeViewModel.fetchRecipeIngredients(widget.recipeId);
    final Recipe recipe = _recipeViewModel.recipes.firstWhere(
      (Recipe r) => r.id == widget.recipeId,
      orElse:
          () => Recipe(
            id: widget.recipeId,
            name: 'Неизвестный рецепт',
            description: '',
            prepareTime: 0,
            categoryId: 0,
          ),
    );
    setState(() {
      _recipe = recipe;
      _ingredients = _recipeViewModel.recipeIngredients;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_recipe == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(_recipe!.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildSectionTitle('Описание'),
            _buildText(_recipe!.description),
            const SizedBox(height: 16),
            _buildSectionTitle('Время приготовления'),
            _buildText('${_recipe!.prepareTime} минут'),
            const SizedBox(height: 16),
            _buildSectionTitle('Ингредиенты'),
            ..._ingredients.map(
              (RecipeIngredientFull ingredient) => ListTile(
                title: Text(ingredient.ingredient.name),
                subtitle: Text(
                  'Ед. изм: ${ingredient.ingredient.unit} | Кол-во: ${ingredient.recipeIngredient.count}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildText(String text) {
    return Text(text, style: const TextStyle(fontSize: 16));
  }
}
