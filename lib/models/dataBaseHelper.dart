import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
      version: 2, // Cambiar la versión para que se ejecute la migración
      onCreate: (db, version) async {
        // Crear tabla de recetas con la nueva columna 'inProduction'
        await db.execute(''' 
          CREATE TABLE recetas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            ingredientes TEXT,
            preparacion TEXT,
            productosAsociados TEXT,
            isMine INTEGER,
            inProduction INTEGER,  
            conteo INTEGER DEFAULT 0,
            imagen TEXT
          )
        ''');

        // Insertar recetas de ejemplo desde JSON
        await _insertInitialData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Si la base de datos es actualizada (versión 2), agregar la columna 'inProduction'
        if (oldVersion < 2) {
          await db.execute(''' 
            ALTER TABLE recetas 
            ADD COLUMN inProduction INTEGER;
          ''');
        }
      },
    );
  }

  Future<void> _insertInitialData(Database db) async {
    final String jsonString = await rootBundle.loadString('assets/data/barista.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    for (var item in jsonData) {
      final receta = Receta(
        nombre: item['nombre'],
        ingredientes: item['ingredientes'],
        preparacion: item['preparacion'],
        productosAsociados: item['productosAsociados'],
        isMine: item['isMine'] == true,
        conteo: item['conteo'] ?? 0,
        imagen: item['imagen'],
        inProduction: item['inProduction'] == true, // Nueva variable inProduction
      );
      await db.insert('recetas', receta.toMap());
    }
  }

  Future<int> insertReceta(Receta receta) async {
    final db = await database;
    return await db.insert('recetas', receta.toMap());
  }

  Future<List<Receta>> getAllRecetas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recetas');

    return List.generate(maps.length, (i) {
      return Receta(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        ingredientes: maps[i]['ingredientes'],
        preparacion: maps[i]['preparacion'],
        productosAsociados: maps[i]['productosAsociados'],
        isMine: maps[i]['isMine'] == 1,
        conteo: maps[i]['conteo'],
        imagen: maps[i]['imagen'],
        inProduction: maps[i]['inProduction'] == 1, // Nueva variable inProduction
      );
    });
  }

  // Función para actualizar una receta
  Future<int> updateReceta(Receta receta) async {
    final db = await database;
    return await db.update(
      'recetas',
      receta.toMap(),
      where: 'id = ?',
      whereArgs: [receta.id],
    );
  }

  Future<void> deleteDatabaseFile() async {
    final path = join(await getDatabasesPath(), 'mi_barista.db');
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
      print("Base de datos eliminada.");
    } else {
      print("No se encontró la base de datos.");
    }
  }
}