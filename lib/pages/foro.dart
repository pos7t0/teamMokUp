import 'package:flutter/material.dart';
import 'package:team_mokup/models/comentario.dart';
import 'package:team_mokup/models/usuario.dart';
import 'package:team_mokup/pages/crearComentario.dart'; // Asegúrate de importar la página de creación

class ForoWeb extends StatefulWidget {
  const ForoWeb({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  State<ForoWeb> createState() => _ForoWebState();
}

class _ForoWebState extends State<ForoWeb> {
  // Lista de comentarios simulada
  List<Comentario> comentarios = [
    Comentario(
      nombre: "Usuario1",
      filtro: "Producto",
      informacion: "Este es el post sobre un producto.",
      like: 10,
      dislike: 2,
    ),
    Comentario(
      nombre: "Usuario2",
      filtro: "Técnica",
      informacion: "Aquí explico una técnica interesante.",
      like: 7,
      dislike: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Combina los comentarios locales con los del singleton
    List<Comentario> comentariosCombinados = [
      ...comentarios,
      ...Usuario.instance.obtenerComentarios()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: comentariosCombinados.length,
        itemBuilder: (context, index) {
          final comentario = comentariosCombinados[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comentario.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Filtro: ${comentario.filtro}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(comentario.informacion),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up),
                            onPressed: () {
                              setState(() {
                                comentario.like++;
                              });
                            },
                          ),
                          Text('${comentario.like}'),
                          IconButton(
                            icon: const Icon(Icons.thumb_down),
                            onPressed: () {
                              setState(() {
                                comentario.dislike++;
                              });
                            },
                          ),
                          Text('${comentario.dislike}'),
                        ],
                      ),
                      // Mostrar el botón de editar solo si el comentario pertenece al usuario
                      if (comentario.nombre == Usuario.instance.nombre) // Verifica si el comentario pertenece al usuario
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            // Navegar a la página de creación/edición de comentarios
                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CrearComentario(comentario: comentario), // Pasar el comentario
                              ),
                            );
                            if (resultado != null) {
                              setState(() {
                                // Actualizar el comentario en el singleton o la lista
                                int indexToUpdate = comentariosCombinados.indexOf(comentario);
                                if (indexToUpdate != -1) {
                                  comentariosCombinados[indexToUpdate] = resultado; // Actualiza el comentario
                                }
                              });
                            }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega a la página de creación de comentarios
          final nuevoComentario = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CrearComentario()),
          );
          if (nuevoComentario != null) {
            setState(() {
              // Agregar el nuevo comentario al singleton
              Usuario.instance.agregarComentario(nuevoComentario);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}