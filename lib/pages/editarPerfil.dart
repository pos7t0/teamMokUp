import 'package:flutter/material.dart';
import 'package:team_mokup/models/usuario.dart'; // Asegúrate de importar el modelo de Usuario

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  // Controladores para los campos de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Inicializar los campos con la información actual del usuario singleton
    final usuario = Usuario.instance;
    _nombreController.text = usuario.nombre;
    _correoController.text = usuario.correo;
  }

  @override
  void dispose() {
    // Limpiar los controladores cuando no se necesiten
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    // Obtener la instancia singleton del usuario
    final usuario = Usuario.instance;

    // Actualizar el nombre y correo con los nuevos valores
    setState(() {
      usuario.nombre = _nombreController.text;
      usuario.correo = _correoController.text;
    });

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado con éxito.')),
    );
    
    // Regresar a la pantalla anterior
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para editar el nombre
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo para editar el correo
            TextFormField(
              controller: _correoController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Botón para guardar cambios
            ElevatedButton(
              onPressed: _guardarCambios,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}