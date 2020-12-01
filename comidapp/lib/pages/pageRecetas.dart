import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecetasComidas extends StatefulWidget {
  RecetasComidas({Key key}) : super(key: key);

  @override
  _RecetasComidasState createState() => _RecetasComidasState();
}

class _RecetasComidasState extends State<RecetasComidas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("RECETAS"),
        ),
      ),
    );
  }
}
