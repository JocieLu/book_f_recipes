class Ingredient {
  final int? id;
  final String unit;
  final String name;

  Ingredient({this.id, required this.unit, required this.name});

  /// Преобразование в Map для SQLite
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'unit': unit, 'name': name};
  }

  /// Создание объекта из Map
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(id: map['id'], unit: map['unit'], name: map['name']);
  }

  /// Метод копирования с изменением отдельных полей
  Ingredient copyWith({int? id, String? unit, String? name}) {
    return Ingredient(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      name: name ?? this.name,
    );
  }
}
