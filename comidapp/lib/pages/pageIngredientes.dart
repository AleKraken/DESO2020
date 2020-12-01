import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ingredientes extends StatefulWidget {
  Ingredientes({Key key}) : super(key: key);

  @override
  _IngredientesState createState() => _IngredientesState();
}

class _IngredientesState extends State<Ingredientes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("INGREDIENTES"),
        ),
      ),
    );
  }
}
