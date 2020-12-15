import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class Ingrediente {
  int idIngrediente;
  String nombreIngrediente;
  int favoritoIngrediente;

  Ingrediente({
    this.idIngrediente,
    this.nombreIngrediente,
    this.favoritoIngrediente,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_IDINGREDIENTE: idIngrediente,
      DatabaseProvider.COLUMN_NOMBREINGREDIENTE: nombreIngrediente,
      DatabaseProvider.COLUMN_FAVORITOINGREDIENTE: favoritoIngrediente,
    };

    if (idIngrediente != null) {
      map[DatabaseProvider.COLUMN_IDINGREDIENTE] = idIngrediente;
    }

    return map;
  }

  Ingrediente.fromMap(Map<String, dynamic> map) {
    idIngrediente = map[DatabaseProvider.COLUMN_IDCOMIDA];
    nombreIngrediente = map[DatabaseProvider.COLUMN_NOMBREINGREDIENTE];
    favoritoIngrediente = map[DatabaseProvider.COLUMN_FAVORITOINGREDIENTE];
  }
}
