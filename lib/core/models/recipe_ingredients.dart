class RecipeIngredients {
  final int? id;
  final double count;
  final int recipeId;
  final int ingredientId;

  RecipeIngredients({
    this.id,
    required this.count,
    required this.recipeId,
    required this.ingredientId,
  });

  /// Преобразование в Map для SQLite
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'count': count,
      'recipeId': recipeId,
      'ingredientId': ingredientId,
    };
  }

  /// Создание объекта из Map
  factory RecipeIngredients.fromMap(Map<String, dynamic> map) {
    return RecipeIngredients(
      id: map['id'],
      count: map['count'],
      recipeId: map['recipeId'],
      ingredientId: map['ingredientId'],
    );
  }

  /// Метод копирования с изменением отдельных полей
  RecipeIngredients copyWith({
    int? id,
    double? count,
    int? recipeId,
    int? ingredientId,
  }) {
    return RecipeIngredients(
      id: id ?? this.id,
      count: count ?? this.count,
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
    );
  }
}
