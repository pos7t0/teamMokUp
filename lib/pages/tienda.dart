import 'package:flutter/material.dart';

class tienda extends StatefulWidget {
  const tienda({super.key, required this.title,required this.color});

  final String title;
  final Color color;

  @override
  State<tienda> createState() => _tiendaState();
}

class _tiendaState extends State<tienda> {


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