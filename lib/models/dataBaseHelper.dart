import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'mi_barista.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE recetas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            ingredientes TEXT,
            preparacion TEXT,
            favorito INTEGER,
            calificacionUsuario REAL,
            imagen TEXT
          )
        ''');
      },
      version: 1,
    );
  }
  

  // Ejemplo de método para insertar una receta
  Future<int> insertReceta(Map<String, dynamic> receta) async {
    final db = await database;
    return await db.insert('recetas', receta);
  }

  // Otros métodos CRUD (consulta, actualización, eliminación) se agregarán aquí
}