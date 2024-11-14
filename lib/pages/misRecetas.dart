import 'package:flutter/material.dart';
import 'dart:io';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/models/dataBaseHelper.dart';
import 'package:team_mokup/pages/crearReceta.dart'; // Importa CrearReceta
import 'package:team_mokup/pages/editarReceta.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MisRecetas extends StatefulWidget {
  const MisRecetas({super.key, required this.title, required this.color});
  final String title;
  final Color color;

  @override
  State<MisRecetas> createState() => _MisRecetasState();
}

class _MisRecetasState extends State<MisRecetas> {
  List<Receta> misRecetas = [];

  @override
  void initState() {
    super.initState();
    _cargarMisRecetas();
  }

  Future<void> _cargarMisRecetas() async {
    final dbHelper = DatabaseHelper();
    final recetas = await dbHelper.getAllRecetas();
    setState(() {
      // Filtra solo las recetas que tengan isMine en true
      misRecetas = recetas.where((receta) => receta.isMine).toList();
    });
  }

  // Verificar si la imagen es un archivo local
  bool esImagenLocal(String? imagenPath) {
    if (imagenPath == null) return false;
    return imagenPath.startsWith('file://');
  }

  // Verifica si el archivo de imagen existe en el sistema de archivos
  Future<bool> _existeArchivo(String? path) async {
    if (path == null) return false;
    final file = File(path);
    return await file.exists();
  }

  Future<void> _editRecipe(Receta receta) async {
    final editedReceta = await showDialog<Receta>(context: context, builder: (context) {
      return EditRecipeDialog(receta: receta);
    });

    if (editedReceta != null) {
      editedReceta.isMine = true;
      final dbHelper = DatabaseHelper();
      await dbHelper.updateReceta(editedReceta);
      _cargarMisRecetas();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Receta actualizada")));
    }
  }

  Future<void> _crearReceta(BuildContext context) async {
    final nuevaReceta = await showDialog<Receta>(context: context, builder: (context) {
      return CrearReceta();
    });

    if (nuevaReceta != null) {
      nuevaReceta.isMine = true;
      nuevaReceta.inProduction = false;
      final dbHelper = DatabaseHelper();
      await dbHelper.insertReceta(nuevaReceta);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Receta creada")));
    }
  }

  // Alternar el estado de inProduction y aumentar el conteo
  Future<void> _toggleInProduction(Receta receta) async {
    // Alternar el valor de 'inProduction'
    receta.inProduction = !(receta.inProduction ?? false);
    
    // Si está en producción, incrementamos el conteo
    if (receta.inProduction == true) {
      receta.conteo = (receta.conteo) + 1;  // Aseguramos que conteo no sea nulo y lo incrementamos
    }

    // Actualizar la receta en la base de datos
    final dbHelper = DatabaseHelper();
    await dbHelper.updateReceta(receta);
    
    // Volver a cargar las recetas para reflejar los cambios
    _cargarMisRecetas();
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
            Expanded(
              child: misRecetas.isEmpty
                  ? const Center(child: Text('No tienes recetas guardadas'))
                  : ListView.builder(
                      itemCount: misRecetas.length,
                      itemBuilder: (context, index) {
                        final receta = misRecetas[index];
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
                                // Mostrar imagen si existe
                                receta.imagen != null
                                    ? (receta.imagen!.startsWith('assets/')
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.asset(
                                              receta.imagen!, // Usamos Image.asset para las imágenes de pubspec.yaml
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

                                              if (snapshot.hasError || !snapshot.data!) {
                                                return const SizedBox(height: 150); // Placeholder si no existe el archivo
                                              }

                                              return ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(receta.imagen!),
                                                  height: 300,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                          ))
                                    : const SizedBox(height: 150), // Placeholder si no hay imagen
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
                                // Agregar productos asociados
                                receta.productosAsociados.isNotEmpty
                                    ? Text(
                                        'Productos Asociados: ${receta.productosAsociados}',
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Coloca los íconos (edit, share, etc.) en una fila
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            _editRecipe(receta);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.share),
                                          onPressed: () {
                                            _shareRecipe(receta);
                                          },
                                        ),
                                        
                                        IconButton(
                                          icon: Icon(
                                            Icons.local_cafe,
                                            color: (receta.inProduction ?? false) ? Colors.black : Colors.grey, // Aseguramos que inProduction no sea null
                                          ),
                                          onPressed: () async {
                                            // Alternar el valor de inProduction y aumentar el conteo
                                            await _toggleInProduction(receta);
                                          },
                                        ),
                                      ],
                                    ),
                                    // Muestra el conteo junto con los íconos
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
            ElevatedButton(
              onPressed: () => _crearReceta(context),
              child: const Text('Crear nueva receta'),
            ),
          ],
        ),
      ),
    );
  }
}
