import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/ingredient.dart';
import '../../viewmodels/ingredient_viewmodel.dart';
import 'ingredient_create_page.dart';
import 'ingredient_edit_page.dart'; // Страница для редактирования ингредиента

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
    _ingredientViewModel.fetchIngredients();
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
            return const Center(child: Text('Ингредиенты не найдены.'));
          }

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              final Ingredient ingredient = ingredients[index];

              return Dismissible(
                key: Key(ingredient.id.toString()),
                background: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.horizontal, // Оба направления
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Свайп слева направо — редактирование
                    Navigator.of(context).push(
                      MaterialPageRoute<dynamic>(
                        builder:
                            (BuildContext context) =>
                                EditIngredientPage(ingredient: ingredient),
                      ),
                    );
                    return false; // Не удаляем
                  } else if (direction == DismissDirection.endToStart) {
                    // Свайп справа налево — удаление
                    final bool? confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Удаление ингредиента'),
                          content: const Text(
                            'Вы уверены, что хотите удалить этот ингредиент?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Удалить'),
                            ),
                          ],
                        );
                      },
                    );
                    return confirmDelete ?? false;
                  }
                  return false;
                },
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    viewModel.deleteIngredient(ingredient.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ингредиент "${ingredient.name}" удален'),
                      ),
                    );
                  }
                },
                child: ListTile(
                  title: Text(ingredient.name),
                  subtitle: Text('Ед. изм: ${ingredient.unit}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder<dynamic>(
              pageBuilder:
                  (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) => const CreateIngredientPage(),
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                const Offset begin = Offset(0.0, 1.0);
                const Offset end = Offset.zero;
                const Curve curve = Curves.easeInOut;

                final Animatable<Offset> slideTween = Tween<Offset>(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));
                final Animation<Offset> slideAnimation = animation.drive(
                  slideTween,
                );
                final Animation<double> fadeAnimation = animation.drive(
                  CurveTween(curve: Curves.easeIn),
                );

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
