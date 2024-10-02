import 'package:flutter/material.dart';
import 'package:team_mokup/models/receta.dart';

class CrearReceta extends StatefulWidget {
  final Receta? receta; // Añadir un parámetro opcional para editar

  const CrearReceta({super.key, this.receta}); // Constructor modificado

  @override
  State<CrearReceta> createState() => _CrearRecetaState();
}

class _CrearRecetaState extends State<CrearReceta> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _preparacionController = TextEditingController();

  bool _favorito = false;

  @override
  void initState() {
    super.initState();
    // Si hay una receta para editar, inicializar los controladores con sus valores
    if (widget.receta != null) {
      _nombreController.text = widget.receta!.nombre;
      _ingredientesController.text = widget.receta!.ingredientes;
      _preparacionController.text = widget.receta!.preparacion;
      _favorito = widget.receta!.favorito;
    }
  }

  void _guardarReceta() {
    final nuevaReceta = Receta(
      nombre: _nombreController.text,
      ingredientes: _ingredientesController.text,
      preparacion: _preparacionController.text,
      listaCalificaciones: [],
      favorito: _favorito,
      calificacionUsuario: 0,
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