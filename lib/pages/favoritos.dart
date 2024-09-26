import 'package:flutter/material.dart';

class favoritos extends StatefulWidget {
  const favoritos({super.key, required this.title,required this.color});

  final String title;
  final Color color;

  @override
  State<favoritos> createState() => _favoritosState();
}

class _favoritosState extends State<favoritos> {


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