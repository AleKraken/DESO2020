import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class Comida {
  int idComida;
  String nombreComida;
  String descripcion;
  int minutosPreparacion;
  String pasosPreparacion;
  int calorias;
  int favoritoComida;

  Comida({
    this.idComida,
    this.nombreComida,
    this.descripcion,
    this.minutosPreparacion,
    this.pasosPreparacion,
    this.calorias,
    this.favoritoComida,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_IDCOMIDA: idComida,
      DatabaseProvider.COLUMN_NOMBRECOMIDA: nombreComida,
      DatabaseProvider.COLUMN_DESCRIPCION: descripcion,
      DatabaseProvider.COLUMN_MINUTOSPREPARACION: minutosPreparacion,
      DatabaseProvider.COLUMN_PASOSPREPARACION: pasosPreparacion,
      DatabaseProvider.COLUMN_CALORIAS: calorias,
      DatabaseProvider.COLUMN_FAVORITOCOMIDA: favoritoComida,
    };

    if (idComida != null) {
      map[DatabaseProvider.COLUMN_IDCOMIDA] = idComida;
    }

    return map;
  }

  Comida.fromMap(Map<String, dynamic> map) {
    idComida = map[DatabaseProvider.COLUMN_IDCOMIDA];
    nombreComida = map[DatabaseProvider.COLUMN_NOMBRECOMIDA];
    descripcion = map[DatabaseProvider.COLUMN_DESCRIPCION];
    minutosPreparacion = map[DatabaseProvider.COLUMN_MINUTOSPREPARACION];
    pasosPreparacion = map[DatabaseProvider.COLUMN_PASOSPREPARACION];
    calorias = map[DatabaseProvider.COLUMN_CALORIAS];
    favoritoComida = map[DatabaseProvider.COLUMN_FAVORITOCOMIDA];
  }
}
