import 'package:flutter/material.dart';
import 'package:team_mokup/models/receta.dart';

class Comentario extends StatefulWidget {
  const Comentario({super.key, required this.title, required this.color});
  final String title;
  final Color color;

  @override
  State<Comentario> createState() => _ComentarioState();
}

class _ComentarioState extends State<Comentario> {
  List<Receta> misRecetas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
      ),
      
    );
  }
}