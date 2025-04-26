class Recipe {
  final int? id; // может быть null при создании нового рецепта
  final String name;
  final String description;
  final int prepareTime;
  final int categoryId;

  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.prepareTime,
    required this.categoryId,
  });

  /// Преобразование объекта в Map для сохранения в БД
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'prepareTime': prepareTime,
      'categoryId': categoryId,
    };
  }

  /// Создание объекта из Map, полученного из БД
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      prepareTime: map['prepareTime'],
      categoryId: map['categoryId'],
    );
  }

  /// Метод для копирования с возможностью изменения отдельных полей
  Recipe copyWith({
    int? id,
    String? name,
    String? description,
    int? prepareTime,
    int? ingridientsId,
    int? categoryId,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      prepareTime: prepareTime ?? this.prepareTime,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
