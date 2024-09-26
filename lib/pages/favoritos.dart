import 'package:flutter/material.dart';

class favoritos extends StatefulWidget {
  const favoritos({super.key, required this.title});

  final String title;

  @override
  State<favoritos> createState() => _favoritosState();
}

class _favoritosState extends State<favoritos> {


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      )
    );
  }
}