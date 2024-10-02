import 'package:flutter/material.dart';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/models/usuario.dart';
import 'package:team_mokup/pages/crearReceta.dart'; // Importa la página para crear recetas

class recetasWeb extends StatefulWidget {
  const recetasWeb({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  State<recetasWeb> createState() => _recetasWebState();
}

class _recetasWebState extends State<recetasWeb> {
  // Lista de recetas originales y lista filtrada
  final List<Receta> recetasOriginales = [
    Receta(
  nombre: 'Café Espresso',
  ingredientes: 'Café molido fino, Agua',
  preparacion: 'Utiliza una máquina de espresso para extraer el café con agua caliente a alta presión durante 25-30 segundos.',
  listaCalificaciones: [4.9, 5.0, 4.8],
  favorito: false,
  calificacionUsuario: 0,
),
Receta(
  nombre: 'Café Americano',
  ingredientes: 'Café espresso, Agua caliente',
  preparacion: 'Prepara un espresso y añade agua caliente para diluir, creando una bebida más suave.',
  listaCalificaciones: [4.7, 4.5],
  favorito: false,
  calificacionUsuario: 0,
),
Receta(
  nombre: 'Café Cold Brew',
  ingredientes: 'Café molido grueso, Agua fría',
  preparacion: 'Mezcla el café con agua fría y déjalo reposar en el refrigerador durante 12-24 horas. Luego filtra el café y sirve con hielo.',
  listaCalificaciones: [4.6, 4.8],
  favorito: false,
  calificacionUsuario: 0,
),
  ];

  List<Receta> recetasFiltradas = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRecetas);
    _updateRecetasFiltradas();
  }

  // Método para filtrar recetas según el texto del buscador
  void _filterRecetas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      recetasFiltradas = _getTodasLasRecetas()
          .where((receta) => receta.nombre.toLowerCase().contains(query))
          .toList();
    });
  }

  // Método para obtener todas las recetas combinadas
  List<Receta> _getTodasLasRecetas() {
    final usuario = Usuario.instance; // Acceder al singleton del usuario
    final recetasUsuario = usuario.recetas; // Recetas del usuario
    return [...recetasOriginales, ...recetasUsuario]; // Combinar ambas listas
  }

  // Actualizar recetas filtradas sin filtro
  void _updateRecetasFiltradas() {
    setState(() {
      recetasFiltradas = _getTodasLasRecetas();
    });
  }

  // Método para crear el widget de estrellas
  Widget _buildRatingStars(Receta receta) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < receta.calificacionUsuario ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              receta.calificacionUsuario = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Usuario.instance; // Acceder al singleton del usuario

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
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar receta...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recetasFiltradas.length, // Mostrar recetas filtradas
                itemBuilder: (context, index) {
                  final receta = recetasFiltradas[index];
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
                          // Nombre de la receta
                          Text(
                            receta.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Ingredientes y preparación
                          Text('Ingredientes: ${receta.ingredientes}'),
                          const SizedBox(height: 5),
                          Text('Preparación: ${receta.preparacion}'),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Calificación promedio y estrellas
                              Column(
                                children: [
                                  Text(
                                    'Respuestas: ${receta.totalCalificaiones}    Calificación: ${receta.calificacionPromedio.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Solo mostrar estrellas si la receta es original
                                  if (recetasOriginales.contains(receta))
                                    _buildRatingStars(receta), // Mostrar estrellas
                                ],
                              ),
                              // Espaciador flexible
                              const Spacer(),
                              // Iconos de compartir y editar
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () {
                                      // Implementar la lógica para compartir
                                    },
                                  ),
                                  // Mostrar botón de favorito solo para las recetas originales
                                  if (recetasOriginales.contains(receta))
                                    IconButton(
                                      icon: Icon(
                                        receta.favorito ? Icons.favorite : Icons.favorite_border,
                                        color: receta.favorito ? Colors.red : null,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          receta.favorito = !receta.favorito;
                                          // Añadir o remover de favoritos en el singleton
                                          if (receta.favorito) {
                                            usuario.agregarFavorito(receta);
                                          } else {
                                            usuario.removerFavorito(receta);
                                          }
                                        });
                                      },
                                    ),
                                  // Mostrar botón de editar solo para recetas del usuario
                                  if (!recetasOriginales.contains(receta))
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        final recetaEditada = await Navigator.push<Receta>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CrearReceta(receta: receta),
                                          ),
                                        );
                              
                                        if (recetaEditada != null) {
                                          setState(() {
                                            usuario.editarReceta(recetaEditada);
                                            _updateRecetasFiltradas(); // Actualizar la lista de recetas
                                          });
                                        }
                                      },
                                    ),
                                ],
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navegar a la página para crear una nueva receta y esperar el resultado
                final nuevaReceta = await Navigator.push<Receta>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CrearReceta(),
                  ),
                );

                // Agregar la nueva receta al singleton y actualizar la vista
                if (nuevaReceta != null) {
                  setState(() {
                    usuario.agregarReceta(nuevaReceta);
                    _updateRecetasFiltradas(); // Actualizar la lista de recetas
                  });
                }
              },
              child: const Text('Crear nueva receta'),
            ),
          ],
        ),
      ),
    );
  }
}