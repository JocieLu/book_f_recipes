import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/ingredient_repository.dart';
import '../../core/models/ingredient.dart';

class IngredientListPage extends StatefulWidget {
  const IngredientListPage({super.key});

  @override
  State<IngredientListPage> createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {
  late IngredientRepository _ingredientRepository;
  List<Ingredient> _ingredients = <Ingredient>[];

  @override
  void initState() {
    super.initState();
    _ingredientRepository = Provider.of<IngredientRepository>(
      context,
      listen: false,
    );
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final List<Ingredient> ingredients =
        await _ingredientRepository.getAllIngredients();
    setState(() {
      _ingredients = ingredients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ингредиенты')),
      body: ListView.builder(
        itemCount: _ingredients.length,
        itemBuilder: (BuildContext context, int index) {
          final Ingredient ingredient = _ingredients[index];
          return ListTile(
            title: Text(ingredient.name),
            subtitle: Text('Ед. изм: ${ingredient.unit}'),
          );
        },
      ),
    );
  }
}
