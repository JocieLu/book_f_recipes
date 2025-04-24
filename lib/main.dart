// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const BookOfRecipesApp());
}

class BookOfRecipesApp extends StatelessWidget {
  const BookOfRecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book of Recipes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const Placeholder(), // пока заглушка, потом будет HomePage
    );
  }
}
