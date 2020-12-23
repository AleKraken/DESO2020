import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class Comida {
  int idComida;
  String nombreComida;
  String categoria;
  String area;
  int minutosPreparacion;
  String pasosPreparacion;
  int calorias;
  String rutaImagen;
  int favoritoComida;
  List<int> listaIngredientesEnComida;
  List<String> listaMedidasIngredientes;

  Comida({
    this.idComida,
    this.nombreComida,
    this.categoria,
    this.area,
    this.minutosPreparacion,
    this.pasosPreparacion,
    this.calorias,
    this.rutaImagen,
    this.favoritoComida,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NOMBRECOMIDA: nombreComida,
      DatabaseProvider.COLUMN_CATEGORIACOMIDA: categoria,
      DatabaseProvider.COLUMN_AREA: area,
      DatabaseProvider.COLUMN_MINUTOSPREPARACION: minutosPreparacion,
      DatabaseProvider.COLUMN_PASOSPREPARACION: pasosPreparacion,
      DatabaseProvider.COLUMN_CALORIAS: calorias,
      DatabaseProvider.COLUMN_RUTAIMAGEN: rutaImagen,
      DatabaseProvider.COLUMN_FAVORITOCOMIDA: favoritoComida,
    };

    return map;
  }

  Comida.fromMap(Map<String, dynamic> map) {
    idComida = map[DatabaseProvider.COLUMN_IDCOMIDA];
    nombreComida = map[DatabaseProvider.COLUMN_NOMBRECOMIDA];
    categoria = map[DatabaseProvider.COLUMN_CATEGORIACOMIDA];
    area = map[DatabaseProvider.COLUMN_AREA];
    minutosPreparacion = map[DatabaseProvider.COLUMN_MINUTOSPREPARACION];
    pasosPreparacion = map[DatabaseProvider.COLUMN_PASOSPREPARACION];
    calorias = map[DatabaseProvider.COLUMN_CALORIAS];
    rutaImagen = map[DatabaseProvider.COLUMN_RUTAIMAGEN];
    favoritoComida = map[DatabaseProvider.COLUMN_FAVORITOCOMIDA];
  }
}
