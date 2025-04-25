class Recipe {
  final int? id; // может быть null при создании нового рецепта
  final String name;
  final String description;
  final int prepareTime;
  final int ingridientsId; // внешний ключ на таблицу Ingridients

  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.prepareTime,
    required this.ingridientsId,
  });

  /// Преобразование объекта в Map для сохранения в БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'prepareTime': prepareTime,
      'ingridientsId': ingridientsId,
    };
  }

  /// Создание объекта из Map, полученного из БД
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      prepareTime: map['prepareTime'],
      ingridientsId: map['ingridientsId'],
    );
  }

  /// Метод для копирования с возможностью изменения отдельных полей
  Recipe copyWith({
    int? id,
    String? name,
    String? description,
    int? prepareTime,
    int? ingridientsId,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      prepareTime: prepareTime ?? this.prepareTime,
      ingridientsId: ingridientsId ?? this.ingridientsId,
    );
  }
}
