import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:team_mokup/models/receta.dart';

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
            productosAsociados TEXT,
            isMine INTEGER,
            conteo INTEGER DEFAULT 0,
            imagen TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Método para insertar una receta en la base de datos
  Future<int> insertReceta(Receta receta) async {
    final db = await database;
    return await db.insert('recetas', receta.toMap());
  }

  
}