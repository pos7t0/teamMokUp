import 'package:flutter/material.dart';
import 'package:team_mokup/models/usuario.dart'; // Importar el singleton del usuario

class favoritosWeb extends StatefulWidget {
  const favoritosWeb({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  State<favoritosWeb> createState() => _favoritosWebState();
}

class _favoritosWebState extends State<favoritosWeb> {
  String searchQuery = '';
  late List recetasFavoritas;

  @override
  void initState() {
    super.initState();
    recetasFavoritas = Usuario.instance.favoritos; // Obtener la lista de favoritos del singleton
  }

  // Método para filtrar las recetas según la búsqueda
  List get filteredRecetasFavoritas {
    if (searchQuery.isEmpty) {
      return recetasFavoritas;
    } else {
      return recetasFavoritas.where((receta) {
        return receta.nombre.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Usuario.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de búsqueda
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar receta...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            // Mostrar recetas favoritas filtradas
            Expanded(
              child: filteredRecetasFavoritas.isEmpty
                  ? const Center(
                      child: Text('No tienes recetas favoritas.'),
                    )
                  : ListView.builder(
                      itemCount: filteredRecetasFavoritas.length,
                      itemBuilder: (context, index) {
                        final receta = filteredRecetasFavoritas[index];
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
                                // Mostrar el nombre de la receta
                                Text(
                                  receta.nombre,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Mostrar los ingredientes
                                Text('Ingredientes: ${receta.ingredientes}'),
                                const SizedBox(height: 5),
                                // Mostrar la preparación
                                Text('Preparación: ${receta.preparacion}'),
                                const SizedBox(height: 5),
                                // Mostrar la calificación promedio
                                Text(
                                  'Nota: ${receta.calificacionPromedio.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    // Botón para compartir
                                    IconButton(
                                      icon: const Icon(Icons.share),
                                      onPressed: () {
                                        // Implementar la lógica para compartir
                                      },
                                    ),
                                    // Botón para agregar o remover de favoritos
                                    IconButton(
                                      icon: Icon(
                                        receta.favorito
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: receta.favorito ? Colors.red : null,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          receta.favorito = !receta.favorito;
                                          if (!receta.favorito) {
                                            usuario.removerFavorito(receta);
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
          ],
        ),
      ),
    );
  }
}