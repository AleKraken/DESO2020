import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class Ingrediente {
  int idIngrediente;
  String nombreIngrediente;
  String rutaImagenIngrediente;
  int favoritoIngrediente;
  int disgustaIngrediente;

  Ingrediente({
    this.idIngrediente,
    this.nombreIngrediente,
    this.rutaImagenIngrediente,
    this.favoritoIngrediente,
    this.disgustaIngrediente,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_IDINGREDIENTE: idIngrediente,
      DatabaseProvider.COLUMN_NOMBREINGREDIENTE: nombreIngrediente,
      DatabaseProvider.COLUMN_RUTAIMAGENINGREDIENTE: rutaImagenIngrediente,
      DatabaseProvider.COLUMN_FAVORITOINGREDIENTE: favoritoIngrediente,
      DatabaseProvider.COLUMN_DISGUSTAINGREDIENTE: disgustaIngrediente,
    };

    if (idIngrediente != null) {
      map[DatabaseProvider.COLUMN_IDINGREDIENTE] = idIngrediente;
    }

    return map;
  }

  Ingrediente.fromMap(Map<String, dynamic> map) {
    idIngrediente = map[DatabaseProvider.COLUMN_IDINGREDIENTE];
    nombreIngrediente = map[DatabaseProvider.COLUMN_NOMBREINGREDIENTE];
    rutaImagenIngrediente = map[DatabaseProvider.COLUMN_RUTAIMAGENINGREDIENTE];
    favoritoIngrediente = map[DatabaseProvider.COLUMN_FAVORITOINGREDIENTE];
    disgustaIngrediente = map[DatabaseProvider.COLUMN_DISGUSTAINGREDIENTE];
  }
}
