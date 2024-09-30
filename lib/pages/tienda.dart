import 'package:flutter/material.dart';

class tiendaWeb extends StatefulWidget {
  const tiendaWeb({super.key, required this.title,required this.color});

  final String title;
  final Color color;

  @override
  State<tiendaWeb> createState() => _tiendaWebState();
}

class _tiendaWebState extends State<tiendaWeb> {


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