// lib/main.dart
import 'package:book_f_recipes/presentation/pages/home_page.dart';
import 'package:book_f_recipes/viewmodels/category_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/database/database_helper.dart';

void main() async {
  // 1. ОБЯЗАТЕЛЬНО: Убедитесь, что Flutter Engine инициализирован
  // Это нужно, если вы вызываете нативные операции (как открытие БД) до runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Инициируем базу данных
  // Простое обращение к инстансу singleton вызовет _initDB, если БД еще не открыта
  // Можно не присваивать результат переменной, если он не нужен сразу в main
  // Важно дождаться завершения, если последующий код runApp зависит от готовой БД,
  // но часто сам DatabaseHelper обрабатывает очередь запросов.
  // Безопаснее всего - дождаться первого открытия:
  try {
    await DatabaseHelper
        .instance
        .database; // Это вызовет _initDB при первом запуске

    print("Database initialized successfully."); // Для отладки
  } catch (e) {
    print("Error initializing database: $e");
    // Здесь можно обработать ошибку инициализации, если это критично для старта приложения
  }

  runApp(const BookOfRecipesApp());
}

class BookOfRecipesApp extends StatelessWidget {
  const BookOfRecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<CategoryViewModel>(
          create: (_) => CategoryViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Book of Recipes',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
