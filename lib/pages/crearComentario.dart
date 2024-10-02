import 'package:flutter/material.dart';
import 'package:team_mokup/models/comentario.dart';
import 'package:team_mokup/models/usuario.dart'; // Asegúrate de importar el modelo de usuario

class CrearComentario extends StatefulWidget {
  final Comentario? comentario; // Agregar un parámetro opcional para editar

  const CrearComentario({super.key, this.comentario}); // Constructor modificado

  @override
  _CrearComentarioState createState() => _CrearComentarioState();
}

class _CrearComentarioState extends State<CrearComentario> {
  String informacion = '';
  String filtroSeleccionado = 'Producto'; // Valor predeterminado para el filtro
  final List<String> filtros = ['Producto', 'Técnica', 'Opinión']; // Opciones de filtro

  @override
  void initState() {
    super.initState();
    // Si hay un comentario para editar, inicializar la información y el filtro
    if (widget.comentario != null) {
      informacion = widget.comentario!.informacion;
      filtroSeleccionado = widget.comentario!.filtro;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el nombre del usuario del singleton
    String nombre = Usuario.instance.nombre; // Suponiendo que tienes una propiedad `nombre` en tu singleton

    return Scaffold(
      appBar: AppBar(title: const Text('Crear/Editar Comentario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar el nombre del usuario en lugar de un TextField
            Text(
              'Nombre: $nombre',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Dropdown para seleccionar el filtro
            DropdownButton<String>(
              value: filtroSeleccionado,
              onChanged: (String? newValue) {
                setState(() {
                  filtroSeleccionado = newValue!;
                });
              },
              items: filtros.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Información'),
              onChanged: (value) {
                informacion = value;
              },
              controller: TextEditingController(text: informacion), // Controlador para mostrar el comentario
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Si se está editando, actualiza el comentario
                if (widget.comentario != null) {
                  widget.comentario!.filtro = filtroSeleccionado;
                  widget.comentario!.informacion = informacion;
                  // Regresar el comentario editado a la página anterior
                  Navigator.pop(context, widget.comentario);
                } else {
                  // Si es un nuevo comentario, crea uno nuevo
                  Comentario nuevoComentario = Comentario(
                    nombre: nombre,
                    filtro: filtroSeleccionado,
                    informacion: informacion,
                    like: 0,
                    dislike: 0,
                  );
                  // Regresar el nuevo comentario a la página anterior
                  Navigator.pop(context, nuevoComentario);
                }
              },
              child: const Text('Guardar Comentario'),
            ),
          ],
        ),
      ),
    );
  }
}