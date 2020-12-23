import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class ComidaHasIngrediente {
  int foreignIdIngrediente;
  int foreignIdComida;
  String medidaIngrediente;

  ComidaHasIngrediente({
    this.foreignIdIngrediente,
    this.foreignIdComida,
    this.medidaIngrediente,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE: foreignIdIngrediente,
      DatabaseProvider.COLUMN_FOREIGN_COMIDA: foreignIdComida,
      DatabaseProvider.COLUMN_MEDIDAINGREDIENTE: medidaIngrediente,
    };

    if (foreignIdIngrediente != null) {
      map[DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE] = foreignIdIngrediente;
    }

    return map;
  }

  ComidaHasIngrediente.fromMap(Map<String, dynamic> map) {
    foreignIdIngrediente = map[DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE];
    foreignIdComida = map[DatabaseProvider.COLUMN_FOREIGN_COMIDA];
    medidaIngrediente = map[DatabaseProvider.COLUMN_MEDIDAINGREDIENTE];
  }
}
