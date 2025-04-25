class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  /// Преобразование в Map для SQLite
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  /// Создание объекта из Map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'], name: map['name']);
  }

  /// Метод копирования с изменением отдельных полей
  Category copyWith({int? id, String? unit, String? name}) {
    return Category(id: id ?? this.id, name: name ?? this.name);
  }
}
