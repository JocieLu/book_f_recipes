import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/ingredient.dart';
import '../../viewmodels/ingredient_viewmodel.dart';

class CreateIngredientPage extends StatefulWidget {
  const CreateIngredientPage({super.key});

  @override
  State<CreateIngredientPage> createState() => _CreateIngredientPageState();
}

class _CreateIngredientPageState extends State<CreateIngredientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _saveIngredient() async {
    final String name = _nameController.text.trim();
    final String unit = _unitController.text.trim();

    if (name.isEmpty || unit.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }

    final Ingredient newIngredient = Ingredient(
      id: null,
      name: name,
      unit: unit,
    );

    final IngredientViewModel viewModel = Provider.of<IngredientViewModel>(
      context,
      listen: false,
    );
    await viewModel.addIngredient(newIngredient);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый ингредиент')),
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
              decoration: const InputDecoration(
                labelText: 'Единица измерения (например, шт, г, мл)',
              ),
            ),
            const SizedBox(height: 32),
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
