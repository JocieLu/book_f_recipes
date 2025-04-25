class RecipeIngredients {
  final int? id;
  final double count;
  final int recipeId;
  final int ingridientsId;

  RecipeIngredients({
    this.id,
    required this.count,
    required this.recipeId,
    required this.ingridientsId,
  });

  /// Преобразование в Map для SQLite
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'count': count,
      'recipeId': recipeId,
      'ingridientsId': ingridientsId,
    };
  }

  /// Создание объекта из Map
  factory RecipeIngredients.fromMap(Map<String, dynamic> map) {
    return RecipeIngredients(
      id: map['id'],
      count: map['count'],
      recipeId: map['recipeId'],
      ingridientsId: map['ingridientsId'],
    );
  }

  /// Метод копирования с изменением отдельных полей
  RecipeIngredients copyWith({
    int? id,
    double? count,
    int? recipeId,
    int? ingridientsId,
  }) {
    return RecipeIngredients(
      id: id ?? this.id,
      count: count ?? this.count,
      recipeId: recipeId ?? this.recipeId,
      ingridientsId: ingridientsId ?? this.ingridientsId,
    );
  }
}
