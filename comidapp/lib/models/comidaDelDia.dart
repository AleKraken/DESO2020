import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class ComidaDelDia {
  int idComidaDelDia;
  String hora;
  String nombre;

  ComidaDelDia({
    this.idComidaDelDia,
    this.hora,
    this.nombre,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_IDCOMIDADELDIA: idComidaDelDia,
      DatabaseProvider.COLUMN_HORA: hora,
      DatabaseProvider.COLUMN_NOMBRECOMIDADELDIA: nombre,
    };

    if (idComidaDelDia != null) {
      map[DatabaseProvider.COLUMN_IDCOMIDADELDIA] = idComidaDelDia;
    }

    return map;
  }

  ComidaDelDia.fromMap(Map<String, dynamic> map) {
    idComidaDelDia = map[DatabaseProvider.COLUMN_IDCOMIDADELDIA];
    hora = map[DatabaseProvider.COLUMN_HORA];
    nombre = map[DatabaseProvider.COLUMN_NOMBRECOMIDADELDIA];
  }
}
