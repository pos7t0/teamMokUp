import 'package:flutter/material.dart';

class tienda extends StatefulWidget {
  const tienda({super.key, required this.title});

  final String title;

  @override
  State<tienda> createState() => _tiendaState();
}

class _tiendaState extends State<tienda> {


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