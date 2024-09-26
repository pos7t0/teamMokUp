import 'package:flutter/material.dart';

class recetas extends StatefulWidget {
  const recetas({super.key, required this.title});

  final String title;

  @override
  State<recetas> createState() => _recetasState();
}

class _recetasState extends State<recetas> {


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
