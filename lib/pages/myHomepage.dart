import 'package:flutter/material.dart';
import 'package:team_mokup/pages/favoritos.dart';
import 'package:team_mokup/pages/recetas.dart';
import 'package:team_mokup/pages/tienda.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card de Recetas
              button(Icons.menu_book, 'Recetas', const recetas(title: 'Recetas')),
              const SizedBox(height: 20),
              // Card de Favoritos
              button(Icons.favorite, 'Favoritos', const favoritos(title: 'Favoritos')),
              
              const SizedBox(height: 20),
              // Card de Tienda
              button(Icons.shopping_cart, 'Tienda', const tienda(title: 'Tienda')),
              
            ],
          ),
        ),
      ),
    );
  }
  GestureDetector button(IconData icon,String text,StatefulWidget state){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => state),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
        ),
        elevation: 4, // Sombra de la card
        child: ListTile(
          leading:  Icon(icon, size: 40), // Icono de recetas
          title:  Text(
            text,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

