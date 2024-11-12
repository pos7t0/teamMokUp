import 'package:flutter/material.dart';
import 'package:team_mokup/models/receta.dart';
import 'package:team_mokup/pages/crearReceta.dart';

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
      productosAsociados: '',
      isMine: false,
      imagen: 'assets/image/descarga.png', // Ruta de la imagen
    ),
    Receta(
      nombre: 'Café Americano',
      ingredientes: 'Café espresso, Agua caliente',
      preparacion: 'Prepara un espresso y añade agua caliente para diluir, creando una bebida más suave.',
      productosAsociados: '',
      isMine: false,
      imagen: 'assets/image/descarga2.png', // Ruta de la imagen
    ),
    Receta(
      nombre: 'Café Cold Brew',
      ingredientes: 'Café molido grueso, Agua fría',
      preparacion: 'Mezcla el café con agua fría y déjalo reposar en el refrigerador durante 12-24 horas. Luego filtra el café y sirve con hielo.',
      productosAsociados: '',
      isMine: false,
      imagen: 'assets/image/descarga.png', // Ruta de la imagen
    ),
  ];

  List<Receta> recetasFiltradas = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recetasFiltradas = List.from(recetasOriginales); // Inicializar recetasFiltradas
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: (value) {
                setState(() {
                  recetasFiltradas = recetasOriginales
                      .where((receta) => receta.nombre.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
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
                          // Mostrar imagen de la receta
                          receta.imagen != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    receta.imagen!,
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el espacio
                                  ),
                                )
                              : const SizedBox(height: 150), // Si no tiene imagen, mostrar espacio vacío

                          const SizedBox(height: 10),
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
                                  // Mostrar botón de editar solo para recetas del usuario
                                  if (receta.isMine)
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
                                            // Actualizar la receta editada en la lista
                                            final index = recetasFiltradas.indexOf(receta);
                                            recetasFiltradas[index] = recetaEditada;
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

                // Agregar la nueva receta y actualizar la vista
                if (nuevaReceta != null) {
                  setState(() {
                    recetasOriginales.add(nuevaReceta);
                    recetasFiltradas = List.from(recetasOriginales);
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