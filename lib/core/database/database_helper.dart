import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Создаем таблицу категорий
    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    // 2. СРАЗУ ЖЕ заполняем ее начальными данными
    // Можно сделать это через batch для эффективности, если категорий много
    Batch batch = db.batch();
    List<String> initialCategories = <String>[
      'Завтраки',
      'Супы',
      'Основные блюда',
      'Салаты',
      'Десерты',
      'Напитки',
    ];

    for (String categoryName in initialCategories) {
      // Используем INSERT OR IGNORE чтобы избежать ошибки если вдруг
      // категория с таким именем уже есть (хотя в _onCreate это маловероятно)
      batch.insert('category', <String, String>{
        'name': categoryName,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true); // Выполняем все операции вставки

    await db.execute('''
      CREATE TABLE ingredient (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        unit TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE recipe (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        prepareTime INTEGER NOT NULL,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES category(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE recipe_ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId INTEGER,
        ingredientId INTEGER,
        count REAL,
        FOREIGN KEY (recipeId) REFERENCES recipe(id),
        FOREIGN KEY (ingredientId) REFERENCES ingredient(id)
      )
    ''');
  }

  Future<void> close() async {
    final Database db = await instance.database;
    db.close();
  }
}
