import 'package:book_f_recipes/core/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/recipe_viewmodel.dart';
import '../../core/models/recipe.dart';
import '../../core/models/recipe_ingredients.dart';

class RecipeCreatePage extends StatefulWidget {
  final int? recipeId; // ID рецепта, если мы редактируем существующий рецепт
  final int categoryId; // добавляем параметр categoryId

  const RecipeCreatePage({
    super.key,
    required this.categoryId,
    this.recipeId, // если передается recipeId, значит редактируем
  });

  @override
  State<RecipeCreatePage> createState() => _RecipeCreatePageState();
}

class _RecipeCreatePageState extends State<RecipeCreatePage> {
  late RecipeViewModel _recipeViewModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prepareTimeController = TextEditingController();

  late int _currentCategoryId;
  late int _currentRecipeId;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _recipeViewModel = Provider.of<RecipeViewModel>(context, listen: false);
    _currentCategoryId = widget.categoryId;

    if (widget.recipeId != null) {
      _isEditing = true;
      _currentRecipeId = widget.recipeId!;
      _loadRecipeData();
    } else {
      _currentRecipeId = -1;
    }
  }

  Future<void> _loadRecipeData() async {
    // Загружаем данные рецепта по его ID, если мы редактируем
    await _recipeViewModel.fetchRecipeIngredients(_currentRecipeId);
    final Recipe recipe = _recipeViewModel.recipes.firstWhere(
      (Recipe recipe) => recipe.id == _currentRecipeId,
    );
    _nameController.text = recipe.name;
    _descriptionController.text = recipe.description;
    _prepareTimeController.text = recipe.prepareTime.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _prepareTimeController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final Recipe newRecipe = Recipe(
      id: _isEditing ? _currentRecipeId : null,
      name: _nameController.text,
      description: _descriptionController.text,
      prepareTime: int.parse(_prepareTimeController.text),
      categoryId: _currentCategoryId,
    );

    if (_isEditing) {
      await _recipeViewModel.addRecipe(newRecipe); // Обновить рецепт
    } else {
      await _recipeViewModel.addRecipe(newRecipe); // Добавить новый рецепт
    }

    if (mounted) {
      Navigator.of(context).pop(); // Вернуться на предыдущую страницу
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать рецепт' : 'Создать рецепт'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название рецепта',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название рецепта';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание рецепта',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите описание рецепта';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prepareTimeController,
                decoration: const InputDecoration(
                  labelText: 'Время приготовления (мин)',
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите время приготовления';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Consumer<RecipeViewModel>(
                builder: (
                  BuildContext context,
                  RecipeViewModel viewModel,
                  Widget? child,
                ) {
                  final List<RecipeIngredientFull> ingredients =
                      viewModel.recipeIngredients;

                  return ingredients.isEmpty
                      ? const Center(child: Text('Ингредиенты не добавлены.'))
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ingredients.length,
                        itemBuilder: (BuildContext context, int index) {
                          final RecipeIngredientFull item = ingredients[index];

                          return ListTile(
                            title: Text(item.ingredient.name),
                            subtitle: Text(
                              'Ед. изм: ${item.ingredient.unit} | Кол-во: ${item.recipeIngredient.count}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                viewModel.deleteRecipeIngredient(
                                  item.recipeIngredient.id!,
                                  item.recipeIngredient.recipeId,
                                );
                              },
                            ),
                          );
                        },
                      );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Открыть страницу добавления ингредиента
                  Navigator.of(context).push(
                    MaterialPageRoute<dynamic>(
                      builder:
                          (_) => AddRecipeIngredientPage(
                            recipeId: _currentRecipeId,
                          ),
                    ),
                  );
                },
                child: const Text('Добавить ингредиент'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: Text(_isEditing ? 'Сохранить' : 'Создать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddRecipeIngredientPage extends StatefulWidget {
  final int recipeId;

  const AddRecipeIngredientPage({super.key, required this.recipeId});

  @override
  State<AddRecipeIngredientPage> createState() =>
      _AddRecipeIngredientPageState();
}

class _AddRecipeIngredientPageState extends State<AddRecipeIngredientPage> {
  late TextEditingController _quantityController;
  int? _ingredientId;

  List<Ingredient> _ingredients = <Ingredient>[];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _ingredientId = null;

    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final RecipeViewModel viewModel = Provider.of<RecipeViewModel>(
      context,
      listen: false,
    );

    _ingredients = await viewModel.fetchAllIngredients();

    setState(() {});
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _addIngredientToRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final RecipeIngredients recipeIngredient = RecipeIngredients(
      recipeId: widget.recipeId,
      ingredientId: _ingredientId!,
      count: double.parse(_quantityController.text),
    );

    await Provider.of<RecipeViewModel>(
      context,
      listen: false,
    ).addRecipeIngredient(recipeIngredient);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить ингредиент')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<int>(
                value: _ingredientId,
                onChanged: (int? value) {
                  setState(() {
                    _ingredientId = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Ингредиент'),
                items:
                    _ingredients.map((dynamic ingredient) {
                      return DropdownMenuItem<int>(
                        value: ingredient.id,
                        child: Text(ingredient.name),
                      );
                    }).toList(),
                validator: (int? value) {
                  if (value == null || value == 0) {
                    return 'Пожалуйста, выберите ингредиент';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Количество'),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addIngredientToRecipe,
                child: const Text('Добавить ингредиент'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
