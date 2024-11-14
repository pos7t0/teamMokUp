import 'package:flutter/material.dart';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/models/dataBaseHelper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:team_mokup/pages/editarReceta.dart';

class recetasWeb extends StatefulWidget {
  const recetasWeb({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  State<recetasWeb> createState() => _recetasWebState();
}

class _recetasWebState extends State<recetasWeb> {
  List<Receta> recetasFiltradas = [];
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _cargarRecetas();
  }

  Future<void> _cargarRecetas() async {
    final recetas = await dbHelper.getAllRecetas();
    setState(() {
      recetasFiltradas = recetas;
    });
  }

  Future<void> _eliminarBaseDeDatos() async {
    await dbHelper.deleteDatabaseFile();
    setState(() {
      recetasFiltradas.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Base de datos eliminada")),
    );
  }

  Future<void> _shareRecipe(Receta receta) async {
    String recipeText = '''
      Receta: ${receta.nombre}
      
      Ingredientes: 
      ${receta.ingredientes}
      
      Preparación: 
      ${receta.preparacion}
      
      Productos relacionados: 
      ${receta.productosAsociados}
      '''; 

    List<XFile> files = [];

    if (receta.imagen != null) {
      final String imagePath = receta.imagen!;

      if (imagePath.startsWith('assets/')) {
        final ByteData byteData = await rootBundle.load(imagePath);
        final tempDir = await getTemporaryDirectory();
        final filePath = path.join(tempDir.path, path.basename(imagePath));
        final file = File(filePath);
        await file.writeAsBytes(byteData.buffer.asUint8List());
        files.add(XFile(filePath));
      } else {
        files.add(XFile(imagePath));
      }
    }

    if (files.isNotEmpty) {
      await Share.shareXFiles(files, text: recipeText);
    } else {
      await Share.share(recipeText);
    }
  }

  Future<void> _editRecipe(Receta receta) async {
    final editedReceta = await showDialog<Receta>( 
      context: context,
      builder: (context) {
        return EditRecipeDialog(receta: receta);
      },
    );

    if (editedReceta != null) {
      editedReceta.isMine = true;
      await dbHelper.updateReceta(editedReceta);
      _cargarRecetas();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Receta actualizada")),
      );
    }
  }

  // Método para alternar el estado de inProduction
  Future<void> _toggleInProduction(Receta receta) async {
  // Alternar el valor de 'inProduction'
    receta.inProduction = !(receta.inProduction ?? false);

    // Si está en producción (receta.inProduction es true), incrementamos el contador
    if (receta.inProduction == true) {
      receta.conteo = (receta.conteo ) + 1;  // Aseguramos que conteo no sea null
    }

    // Actualizar la receta en la base de datos
    await dbHelper.updateReceta(receta);

    // Volver a cargar las recetas para reflejar los cambios
    _cargarRecetas();
  }

  // Función para verificar si un archivo existe en el sistema de archivos
  Future<bool> _existeArchivo(String? pathImagen) async {
    if (pathImagen == null) return false;
    final file = File(pathImagen);
    return file.exists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar receta...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    // Si el texto está vacío, recargar todas las recetas
                    _cargarRecetas();
                  } else {
                    // Filtrar las recetas según el valor de búsqueda
                    recetasFiltradas = recetasFiltradas
                        .where((receta) => receta.nombre.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  }
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recetasFiltradas.length,
                itemBuilder: (context, index) {
                  final receta = recetasFiltradas[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          receta.imagen != null
                              ? (receta.imagen!.startsWith('assets/')
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        receta.imagen!,  // Usamos Image.asset para las imágenes de pubspec.yaml
                                        height: 300,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : FutureBuilder<bool>(
                                      future: _existeArchivo(receta.imagen),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator());
                                        }

                                        if (snapshot.data == true) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.file(
                                              File(receta.imagen!),
                                              height: 300,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox(height: 150);
                                        }
                                      },
                                    ))
                              : const SizedBox(height: 150),
                          const SizedBox(height: 10),
                          Text(
                            receta.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Ingredientes: ${receta.ingredientes}'),
                          const SizedBox(height: 5),
                          Text('Preparación: ${receta.preparacion}'),
                          const SizedBox(height: 10),
                          Text('Productos relacionados: ${receta.productosAsociados}'),
                          const SizedBox(height: 10),
                          // Agregar el conteo junto a los iconos
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Los íconos
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await _editRecipe(receta);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () async {
                                      await _shareRecipe(receta);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.local_cafe,
                                      color: (receta.inProduction ?? false) ? Colors.black : Colors.grey, // Aseguramos que inProduction no sea null
                                    ),
                                    onPressed: () async {
                                      // Alternar el valor de inProduction al presionar el ícono
                                      await _toggleInProduction(receta);
                                    },
                                  ),
                                ],
                              ),
                              // Conteo de veces preparado
                              Text(
                                'Veces preparado: ${receta.conteo}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}