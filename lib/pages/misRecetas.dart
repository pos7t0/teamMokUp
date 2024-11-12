import 'package:flutter/material.dart';
import 'package:team_mokup/pages/crearReceta.dart';
import 'package:team_mokup/models/receta.dart';

class MisRecetas extends StatefulWidget {
  const MisRecetas({super.key, required this.title, required this.color});
  final String title;
  final Color color;

  @override
  State<MisRecetas> createState() => _MisRecetasState();
}

class _MisRecetasState extends State<MisRecetas> {
  List<Receta> misRecetas = [];

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
            Expanded(
              child: misRecetas.isEmpty
                  ? const Center(child: Text('No tienes recetas guardadas'))
                  : ListView.builder(
                      itemCount: misRecetas.length,
                      itemBuilder: (context, index) {
                        final receta = misRecetas[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(receta.nombre),
                            subtitle: Text(receta.ingredientes),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () async {
                final nuevaReceta = await Navigator.push<Receta>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CrearReceta(),
                  ),
                );
                
                // Si se creó una nueva receta, agregarla a la lista y actualizar la vista
                if (nuevaReceta != null) {
                  setState(() {
                    misRecetas.add(nuevaReceta);
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