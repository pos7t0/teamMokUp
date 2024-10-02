import 'package:flutter/material.dart';
import 'package:team_mokup/models/comentario.dart'; // Asegúrate de importar la clase Comentario
import 'package:team_mokup/models/usuario.dart'; // Asegúrate de importar la clase Usuario
import 'package:team_mokup/pages/crearComentario.dart'; // Asegúrate de importar la página de creación de comentarios

class MisComentarios extends StatefulWidget {
  const MisComentarios({super.key});

  @override
  State<MisComentarios> createState() => _MisComentariosState();
}

class _MisComentariosState extends State<MisComentarios> {
  @override
  Widget build(BuildContext context) {
    final usuario = Usuario.instance; // Obtener el usuario singleton
    final List<Comentario> comentarios = usuario.obtenerComentarios(); // Obtener los comentarios del usuario

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Comentarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: comentarios.length,
          itemBuilder: (context, index) {
            final comentario = comentarios[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${comentario.nombre}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('Filtro: ${comentario.filtro}'),
                    const SizedBox(height: 5),
                    Text('Información: ${comentario.informacion}'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navegar a la página de creación/edición de comentarios
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CrearComentario(comentario: comentario), // Pasar el comentario a editar
                              ),
                            ).then((nuevoComentario) {
                              if (nuevoComentario != null) {
                                // Actualizar el comentario si se edita
                                setState(() {});
                              }
                            });
                          },
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
      
    );
  }
}