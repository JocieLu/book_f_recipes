import 'package:book_f_recipes/core/models/ingredient.dart';
import 'package:book_f_recipes/viewmodels/ingredient_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditIngredientPage extends StatefulWidget {
  final Ingredient ingredient;

  const EditIngredientPage({super.key, required this.ingredient});

  @override
  State<EditIngredientPage> createState() => _EditIngredientPageState();
}

class _EditIngredientPageState extends State<EditIngredientPage> {
  late TextEditingController _nameController;
  late TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ingredient.name);
    _unitController = TextEditingController(text: widget.ingredient.unit);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _saveIngredient() async {
    final Ingredient updatedIngredient = widget.ingredient.copyWith(
      name: _nameController.text.trim(),
      unit: _unitController.text.trim(),
    );

    final IngredientViewModel ingredientViewModel =
        Provider.of<IngredientViewModel>(context, listen: false);
    await ingredientViewModel.updateIngredient(updatedIngredient);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Изменить ингредиент')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _unitController,
              decoration: const InputDecoration(labelText: 'Ед. измерения'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveIngredient,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
