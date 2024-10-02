import 'package:flutter/material.dart';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/models/usuario.dart';
import 'package:team_mokup/pages/crearReceta.dart'; // Importar la página de creación/edición de recetas

class MisRecetas extends StatefulWidget {
  const MisRecetas({super.key});

  @override
  State<MisRecetas> createState() => _MisRecetasState();
}

class _MisRecetasState extends State<MisRecetas> {
  @override
  Widget build(BuildContext context) {
    final usuario = Usuario.instance; // Accedemos al singleton del usuario
    final recetasUsuario = usuario.recetas; // Obtenemos las recetas del usuario

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Recetas'),
      ),
      body: ListView.builder(
        itemCount: recetasUsuario.length,
        itemBuilder: (context, index) {
          final receta = recetasUsuario[index];
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
                  Row(
                    children: [
                      // Botón para compartir la receta
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // Implementar la lógica para compartir
                        },
                      ),
                      // Botón para editar la receta
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          // Navegar a la página de crear/editar receta y esperar el resultado
                          final recetaEditada = await Navigator.push<Receta>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CrearReceta(receta: receta),
                            ),
                          );

                          // Si se editó la receta, actualizarla en el singleton y en la lista
                          if (recetaEditada != null) {
                            setState(() {
                              usuario.editarReceta(recetaEditada); // Actualiza en el singleton
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
    );
  }
}