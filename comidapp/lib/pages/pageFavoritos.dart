import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favoritos extends StatefulWidget {
  Favoritos({Key key}) : super(key: key);

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("FAVORITOS"),
        ),
      ),
    );
  }
}
