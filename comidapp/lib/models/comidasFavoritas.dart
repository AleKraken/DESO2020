import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class ComidaFavorita {
  int foreignIdComida;

  ComidaFavorita({
    this.foreignIdComida,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_FOREIGN_COMIDA: foreignIdComida,
    };

    if (foreignIdComida != null) {
      map[DatabaseProvider.COLUMN_FOREIGN_INGREDIENTE] = foreignIdComida;
    }

    return map;
  }

  ComidaFavorita.fromMap(Map<String, dynamic> map) {
    foreignIdComida = map[DatabaseProvider.COLUMN_FOREIGN_COMIDA];
  }
}
