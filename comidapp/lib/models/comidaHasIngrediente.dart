import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class ComidaHasIngrediente {
  int foreignIdIngrediente;
  int foreignIdComida;

  ComidaHasIngrediente({
    this.foreignIdIngrediente,
    this.foreignIdComida,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE: foreignIdIngrediente,
      DatabaseProvider.COLUMN_FOREIGN_COMIDA: foreignIdComida,
    };

    if (foreignIdIngrediente != null) {
      map[DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE] = foreignIdIngrediente;
    }

    return map;
  }

  ComidaHasIngrediente.fromMap(Map<String, dynamic> map) {
    foreignIdIngrediente = map[DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE];
    foreignIdComida = map[DatabaseProvider.COLUMN_FOREIGN_COMIDA];
  }
}
