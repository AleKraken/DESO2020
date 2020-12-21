import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class IngredienteFavorito {
  int foreignIdIngrediente;

  IngredienteFavorito({
    this.foreignIdIngrediente,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE: foreignIdIngrediente,
    };

    if (foreignIdIngrediente != null) {
      map[DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE] = foreignIdIngrediente;
    }

    return map;
  }

  IngredienteFavorito.fromMap(Map<String, dynamic> map) {
    foreignIdIngrediente = map[DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE];
  }
}
