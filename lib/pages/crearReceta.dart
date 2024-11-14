import 'package:flutter/material.dart';
import 'dart:io';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/pages/camara.dart';  // Página para tomar foto

class CrearReceta extends StatefulWidget {
  const CrearReceta({Key? key}) : super(key: key);

  @override
  _CrearRecetaState createState() => _CrearRecetaState();
}

class _CrearRecetaState extends State<CrearReceta> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _preparacionController = TextEditingController();
  final TextEditingController _productosAsociadosController = TextEditingController();

  File? _imageFile;

  // Guardar la receta con la imagen
  void _guardarReceta() {
    final nuevaReceta = Receta(
      nombre: _nombreController.text,
      ingredientes: _ingredientesController.text,
      preparacion: _preparacionController.text,
      productosAsociados: _productosAsociadosController.text,
      imagen: _imageFile?.path,
      isMine: true,
      inProduction: false,
      conteo: 0, // El conteo comienza en 0 por defecto
    );

    Navigator.pop(context, nuevaReceta); // Retorna la receta creada
  }

  // Función para abrir la cámara y tomar foto
  Future<void> _tomarFoto() async {
    // Navegar a la pantalla de cámara
    final image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image); // Ahora recibimos una ruta de archivo (String), que es válida para crear un File.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Receta'),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ingredientesController,
                decoration: const InputDecoration(labelText: 'Ingredientes'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _preparacionController,
                decoration: const InputDecoration(labelText: 'Preparación'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _productosAsociadosController,
                decoration: const InputDecoration(labelText: 'Productos Asociados'),
              ),
              const SizedBox(height: 10),
              // Eliminar el campo de conteo, ya que siempre comienza en 0
              // const SizedBox(height: 10),
              // TextField(
              //   controller: _conteoController,
              //   decoration: const InputDecoration(labelText: 'Conteo'),
              //   keyboardType: TextInputType.number,
              // ),
              const SizedBox(height: 10),

              // Mostrar la imagen seleccionada si existe
              _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _imageFile!,
                        height: 300, // Ajusta la altura según lo que necesites
                        width: double.infinity, // Esto permite que ocupe todo el ancho disponible
                        fit: BoxFit.contain, // Asegura que la imagen no se distorsione
                      ),
                    )
                  : const Text('No se ha seleccionado ninguna imagen.'),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Tomar Foto'),
                onPressed: _tomarFoto, // Abrir la cámara
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cierra el diálogo sin guardar
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: _guardarReceta, // Llama a la función para guardar
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}