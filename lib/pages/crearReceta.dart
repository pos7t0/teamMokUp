import 'package:flutter/material.dart';
import 'package:team_mokup/models/receta.dart';

class CrearReceta extends StatefulWidget {
  final Receta? receta; // Parámetro opcional para editar una receta

  const CrearReceta({super.key, this.receta}); // Constructor modificado

  @override
  State<CrearReceta> createState() => _CrearRecetaState();
}

class _CrearRecetaState extends State<CrearReceta> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _preparacionController = TextEditingController();
  final TextEditingController _productosAsociadosController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();
  final TextEditingController _conteoController = TextEditingController();

  bool _isMine = false;

  @override
  void initState() {
    super.initState();
    // Si hay una receta para editar, inicializar los controladores con sus valores
    if (widget.receta != null) {
      _nombreController.text = widget.receta!.nombre;
      _ingredientesController.text = widget.receta!.ingredientes;
      _preparacionController.text = widget.receta!.preparacion;
      _productosAsociadosController.text = widget.receta!.productosAsociados;
      _imagenController.text = widget.receta!.imagen ?? '';
      _conteoController.text = widget.receta!.conteo.toString();
      _isMine = widget.receta!.isMine;
    }
  }

  void _guardarReceta() {
    // Convertir el conteo de texto a entero
    final conteo = int.tryParse(_conteoController.text) ?? 0;

    final nuevaReceta = Receta(
      nombre: _nombreController.text,
      ingredientes: _ingredientesController.text,
      preparacion: _preparacionController.text,
      productosAsociados: _productosAsociadosController.text,
      imagen: _imagenController.text.isNotEmpty ? _imagenController.text : null,
      isMine: _isMine,
      conteo: conteo,
    );

    // Devuelve la receta creada o editada a la pantalla anterior
    Navigator.pop(context, nuevaReceta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear nueva receta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre de la receta'),
            ),
            TextField(
              controller: _ingredientesController,
              decoration: const InputDecoration(labelText: 'Ingredientes'),
            ),
            TextField(
              controller: _preparacionController,
              decoration: const InputDecoration(labelText: 'Preparación'),
            ),
            TextField(
              controller: _productosAsociadosController,
              decoration: const InputDecoration(labelText: 'Productos Asociados'),
            ),
            TextField(
              controller: _imagenController,
              decoration: const InputDecoration(labelText: 'URL de la Imagen'),
            ),
            TextField(
              controller: _conteoController,
              decoration: const InputDecoration(labelText: 'Conteo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Es mi receta'),
                Checkbox(
                  value: _isMine,
                  onChanged: (value) {
                    setState(() {
                      _isMine = value ?? false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarReceta,
              child: const Text('Guardar receta'),
            ),
          ],
        ),
      ),
    );
  }
}