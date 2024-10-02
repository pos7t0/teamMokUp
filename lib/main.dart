import 'package:flutter/material.dart';
import 'package:team_mokup/models/usuario.dart';
import 'package:team_mokup/pages/activateAccount.dart';


void main() {
  Usuario.instance.inicializarUsuario(
    nombre: 'Juan Perez',
    correo: 'juan@example.com',
    contrasena: '12345',
    recetas: [], // Lista de recetas inicial
    favoritos: [], // Lista de favoritos inicial
    comentarios:[]
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ActivateAccount(),
    );
  }
}


