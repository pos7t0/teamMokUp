import 'package:flutter/material.dart';
import 'package:team_mokup/models/usuario.dart';
import 'package:team_mokup/pages/activateAccount.dart';
import 'package:team_mokup/pages/editarPerfil.dart';
import 'package:team_mokup/pages/misRecetas.dart';
import 'package:team_mokup/pages/misComentarios.dart'; // Importa la página de comentarios

class MyAccount extends StatefulWidget {
  const MyAccount({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    final usuario = Usuario.instance; // Obtenemos la instancia del usuario singleton

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Foto de perfil y nombre
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage('assets/profile_picture.png'), // Imagen de perfil
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario.nombre, // Accede al nombre del usuario desde el singleton
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      usuario.correo, // Accede al correo del usuario desde el singleton
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Sección de editar perfil
            ListTile(
              leading: const Icon(Icons.engineering, color: Colors.red),
              title: const Text('Editar Perfil'),
              subtitle: const Text('Edita tu perfil de usuario'),
              onTap: () {
                // Acción para editar el perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditarPerfil()),
                );
              },
            ),
            const Divider(),
            // Sección de Mis Recetas
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Mis Recetas'),
              subtitle: const Text('Ver todas las recetas que has creado'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MisRecetas()),
                );
              },
            ),
            const Divider(),
            // Sección de Mis Comentarios
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text('Mis Comentarios'),
              subtitle: const Text('Ver todos los comentarios que has realizado'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MisComentarios()), // Navega a la pantalla de comentarios
                );
              },
            ),
            const Divider(),
            // Botón de Cerrar Sesión
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Acción de cerrar sesión
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ActivateAccount(), // Navega a la pantalla de inicio de sesión
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}