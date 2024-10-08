import 'package:flutter/material.dart';
import 'package:team_mokup/pages/favoritos.dart';
import 'package:team_mokup/pages/myAccount.dart';
import 'package:team_mokup/pages/recetas.dart';
import 'package:team_mokup/pages/foro.dart';



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
    
    recetasWeb(title: 'Recetas',color:Color.fromARGB(255, 181, 130, 111)),
    favoritosWeb(title: 'Favoritos',color: Color.fromARGB(255, 255, 138, 130)),
    ForoWeb(title: 'Foro', color: Color.fromARGB(255, 255, 246, 165)),
    MyAccount(title: "Cuenta", color:Color.fromARGB(255, 42, 159, 167)),
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
            icon: Icon(Icons.menu_book),

            label: 'Recetas',
            backgroundColor: Color.fromARGB(255, 181, 130, 111),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
            backgroundColor: Color.fromARGB(255, 255, 138, 130),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Foro',
            backgroundColor: Color.fromARGB(255, 255, 246, 165),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),

            label: 'cuenta',
            backgroundColor: Color.fromARGB(255, 42, 159, 167),
          ),
        ],
        currentIndex: _selectedIndex, // Página seleccionada
        selectedItemColor: Colors.black, // Color del ítem seleccionado
        onTap: _onItemTapped, // Cambiar la página al tocar un ítem
      ),
    );
  }
}

