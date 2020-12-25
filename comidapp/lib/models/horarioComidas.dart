import 'dart:core';

import 'package:comidapp/DB/dataBaseProvider.dart';

class HorarioComida {
  int idComidaHorario;
  int foreignIdComida;
  int diaSemana;
  int foreignIdComidaDelDia;

  HorarioComida({
    this.idComidaHorario,
    this.foreignIdComida,
    this.diaSemana,
    this.foreignIdComidaDelDia,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_IDCOMIDAHORARIO: idComidaHorario,
      DatabaseProvider.COLUMN_FOREIGN_COMIDA: foreignIdComida,
      DatabaseProvider.COLUMN_DIASEMANA: diaSemana,
      DatabaseProvider.COLUMN_FOREIGN_COMIDA_DEL_DIA: foreignIdComidaDelDia,
    };

    return map;
  }

  HorarioComida.fromMap(Map<String, dynamic> map) {
    idComidaHorario = map[DatabaseProvider.COLUMN_IDCOMIDAHORARIO];
    foreignIdComida = map[DatabaseProvider.COLUMN_FOREIGN_COMIDA];
    diaSemana = map[DatabaseProvider.COLUMN_DIASEMANA];
    foreignIdComidaDelDia = map[DatabaseProvider.COLUMN_FOREIGN_COMIDA_DEL_DIA];
  }
}
