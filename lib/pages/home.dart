import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/models/dataBaseHelper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class home extends StatefulWidget {
  const home({super.key, required this.title, required this.color});
  final String title;
  final Color color;

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<Receta> misRecetas = [];
  Receta? recetaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarMisRecetas();
  }

  Future<void> _cargarMisRecetas() async {
    final dbHelper = DatabaseHelper();
    final recetas = await dbHelper.getAllRecetas();
    setState(() {
      misRecetas = recetas;
      recetaSeleccionada = seleccionarRecetaAleatoria();
    });
  }

  // Seleccionar receta al azar con ponderación de acuerdo al conteo
  Receta? seleccionarRecetaAleatoria() {
    if (misRecetas.isEmpty) return null;

    int sumaConteos = misRecetas.fold(0, (total, receta) => total + receta.conteo);

    if (sumaConteos == 0) {
      return misRecetas[Random().nextInt(misRecetas.length)];
    }

    int randomNum = Random().nextInt(sumaConteos);
    int acumulado = 0;
    for (var receta in misRecetas) {
      acumulado += receta.conteo;
      if (randomNum < acumulado) {
        return receta;
      }
    }
    return null;
  }

  // Alternar el estado de inProduction y aumentar el conteo
  Future<void> _toggleInProduction(Receta receta) async {
    receta.inProduction = !(receta.inProduction ?? false);
    if (receta.inProduction == true) {
      receta.conteo = (receta.conteo) + 1;
    }
    final dbHelper = DatabaseHelper();
    await dbHelper.updateReceta(receta);
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
    // Filtrar recetas que están en producción
    List<Receta> recetasEnProduccion = misRecetas.where((receta) => receta.inProduction == true).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar la receta seleccionada al azar
            recetaSeleccionada != null
                ? Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mostrar imagen
                        if (recetaSeleccionada!.imagen != null &&
                            recetaSeleccionada!.imagen!.startsWith('assets/'))
                          Image.asset(
                            recetaSeleccionada!.imagen!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          )
                        else if (recetaSeleccionada!.imagen != null)
                          Image.file(
                            File(recetaSeleccionada!.imagen!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            recetaSeleccionada!.nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ingredientes: ${recetaSeleccionada!.ingredientes}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Preparación: ${recetaSeleccionada!.preparacion}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Productos asociados: ${recetaSeleccionada!.productosAsociados}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                recetaSeleccionada!.inProduction == true
                                    ? Icons.local_cafe  // Ícono de café si está en producción
                                    : Icons.local_cafe_outlined,  // Ícono de café contorneado si no está en producción
                                color: recetaSeleccionada!.inProduction == true
                                    ? Colors.black  // Color negro si está en producción
                                    : Colors.grey,  // Color gris si no está en producción
                              ),
                              onPressed: () {
                                setState(() {
                                  _toggleInProduction(recetaSeleccionada!);  // Alternar el estado de inProduction
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                _shareRecipe(recetaSeleccionada!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      "No hay recetas disponibles",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),

            // Mostrar las recetas en producción
            if (recetasEnProduccion.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                "Recetas en producción:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recetasEnProduccion.length,
                itemBuilder: (context, index) {
                  final receta = recetasEnProduccion[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(top: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: receta.imagen != null && receta.imagen!.startsWith('assets/')
                          ? Image.asset(
                              receta.imagen!,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : receta.imagen != null
                              ? Image.file(
                                  File(receta.imagen!),
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                )
                              : const Icon(Icons.image),
                      title: Text(receta.nombre),
                      subtitle: Text("Veces Preparado: ${receta.conteo}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              _shareRecipe(receta);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
