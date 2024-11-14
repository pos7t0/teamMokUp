import 'package:flutter/material.dart';
import 'dart:io';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/pages/camara.dart';  // Página para tomar foto

class EditRecipeDialog extends StatefulWidget {
  final Receta receta;
  const EditRecipeDialog({super.key, required this.receta});

  @override
  State<EditRecipeDialog> createState() => _EditRecipeDialogState();
}

class _EditRecipeDialogState extends State<EditRecipeDialog> {
  late TextEditingController _nombreController;
  late TextEditingController _ingredientesController;
  late TextEditingController _preparacionController;
  late TextEditingController _productosAsociadosController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.receta.nombre);
    _ingredientesController = TextEditingController(text: widget.receta.ingredientes);
    _preparacionController = TextEditingController(text: widget.receta.preparacion);
    _productosAsociadosController = TextEditingController(text: widget.receta.productosAsociados);
    // Asignamos la ruta de la imagen, ya sea desde un archivo o desde los assets
    _imageFile = widget.receta.imagen != null && !widget.receta.imagen!.startsWith('assets/')
        ? File(widget.receta.imagen!) : null;
  }

  // Función para abrir la cámara y tomar foto
  Future<void> _tomarFoto() async {
    final image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image); // Recibimos una ruta de archivo (String), que es válida para crear un File.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Receta"),
      content: SizedBox(
        width: double.maxFinite, // Asegura que el contenido se expanda al máximo disponible
        child: SingleChildScrollView( // Esto permite desplazamiento si el contenido es grande
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
                  : widget.receta.imagen != null && widget.receta.imagen!.startsWith('assets/')
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            widget.receta.imagen!,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const Text('No se ha seleccionado ninguna imagen.'),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Tomar Foto'),
                onPressed: _tomarFoto, // Abre la cámara para tomar la foto
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
          onPressed: () {
            // Guardamos los datos editados
            widget.receta.nombre = _nombreController.text;
            widget.receta.ingredientes = _ingredientesController.text;
            widget.receta.preparacion = _preparacionController.text;
            widget.receta.productosAsociados = _productosAsociadosController.text;
            widget.receta.imagen = _imageFile?.path ?? widget.receta.imagen; // Actualizamos la imagen si se tomó una nueva
            widget.receta.isMine = true;

            Navigator.pop(context, widget.receta); // Regresamos la receta editada
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}