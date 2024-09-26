import 'package:flutter/material.dart';

class recetas extends StatefulWidget {
  const recetas({super.key, required this.title,required this.color});

  final String title;
  final Color color;

  @override
  State<recetas> createState() => _recetasState();
}

class _recetasState extends State<recetas> {


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      )
    );
  }
}
