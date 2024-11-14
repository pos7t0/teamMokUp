import 'package:flutter/material.dart';
import 'package:team_mokup/pages/home.dart';
import 'package:team_mokup/pages/opinion.dart';
import 'package:team_mokup/pages/misRecetas.dart';
import 'package:team_mokup/pages/recetas.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
int _selectedIndex = 0; // Índice seleccionado para las páginas


  // Lista de las páginas que quieres mostrar
  static const List<Widget> _pages = <Widget>[
    home(title: "Menu Principal", color: Color.fromARGB(255, 168, 71, 36)),
    recetasWeb(title: 'Recetas',color:Color.fromARGB(255, 181, 130, 111)),
    MisRecetas(title: 'Mis Recetas', color: Color.fromARGB(255, 253, 142, 78)),
    Opinion(title: "Comentario", color: Color.fromARGB(255, 253, 231, 107))
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: _pages[_selectedIndex], // Mostrar la página seleccionada
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting, // Cambiar el tipo a shifting
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            label: 'Casa',
            backgroundColor: Color.fromARGB(255, 168, 71, 36),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Recetas',
            backgroundColor: Color.fromARGB(255, 181, 130, 111),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_maker),
            label: 'Mis Creaciones',
            backgroundColor: Color.fromARGB(255, 253, 142, 78),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Comentario',
            backgroundColor: Color.fromARGB(255, 253, 231, 107),
          ),
          
        ],
        currentIndex: _selectedIndex, // Página seleccionada
        selectedItemColor: Colors.black, // Color del ítem seleccionado
        onTap: _onItemTapped, // Cambiar la página al tocar un ítem
      ),
    );
  }
}

