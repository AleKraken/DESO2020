import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/Notifiers/comidaNotifier.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/models/comidaDelDia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OpcionesComida extends StatelessWidget {
  final BuildContext context;
  final Comida comida;
  final int index;
  final ComidaNotifier comidaNotifier;

  const OpcionesComida(
      this.context, this.comida, this.index, this.comidaNotifier);

  @override
  Widget build(context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          width: 45,
          height: 4,
          margin: EdgeInsets.only(bottom: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200),
            color: Colors.grey[300].withOpacity(.5),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          ),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 0),
                childAnimationBuilder: (widget) => SlideAnimation(
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  Text("¿En qué día quieres esta comida?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Divider(height: 20, color: Colors.transparent),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 80,
                          maxWidth: 80,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 13,
                                color: Theme.of(context).shadowColor,
                                offset: const Offset(-1, 0),
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  'assets/images/comidaCargando.jpg'),
                              image: NetworkImage(
                                '${comida.rutaImagen}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 2,
                        ),
                        child: Text("${comida.nombreComida}",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline2),
                      ),
                    ],
                  ),
                  Divider(height: 20, color: Colors.transparent),
                  botonDia(1, "Lunes", context, index),
                  Divider(height: 10, color: Colors.transparent),
                  botonDia(2, "Martes", context, index),
                  Divider(height: 10, color: Colors.transparent),
                  botonDia(3, "Miércoles", context, index),
                  Divider(height: 10, color: Colors.transparent),
                  botonDia(4, "Jueves", context, index),
                  Divider(height: 10, color: Colors.transparent),
                  botonDia(5, "Viernes", context, index),
                  Divider(height: 10, color: Colors.transparent),
                  botonDia(6, "Sábado", context, index),
                  Divider(height: 10, color: Colors.transparent),
                  botonDia(7, "Domingo", context, index),
                  Divider(height: 10, color: Colors.transparent),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget botonDia(int diaInt, String diaStr, context, int indexComida) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme.of(context).buttonColor,
          Color(0xFF038DB2),
        ]),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: FlatButton(
        onPressed: () {
          mostrarOpcionesHorario2(context, indexComida, diaInt, diaStr);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          height: 30,
          width: MediaQuery.of(context).size.width,
          child: Text("$diaStr",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: Colors.white)),
        ),
      ),
    );
  }

  mostrarOpcionesHorario2(
      context, int indexComida, int diaElegido, String diaStr) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setLocalState) {
            return Wrap(
              alignment: WrapAlignment.center,
              children: [
                Container(
                  width: 45,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Colors.grey[300].withOpacity(.5),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                  ),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        delay: Duration(milliseconds: 30),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          Text("Elige una hora",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline3),
                          Divider(height: 20, color: Colors.transparent),
                          botonesComidaDelDia(index, diaElegido, diaStr),
                          Divider(height: 10, color: Colors.transparent),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget botonesComidaDelDia(context, int diaElegido, String diaStr) {
    List<ComidaDelDia> listaComidasDelDia = new List<ComidaDelDia>();
    List<Widget> listaBotones = new List<Widget>();

    return FutureBuilder(
      future: DatabaseProvider.db
          .getComidasDelDia()
          .then((listaComidas) => listaComidasDelDia = listaComidas),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          for (int i = 0; i < listaComidasDelDia.length; i++) {
            listaBotones.add(
              Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Theme.of(context).buttonColor,
                    Color(0xFF038DB2),
                  ]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Theme.of(context).shadowColor,
                      offset: const Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: FlatButton(
                  onPressed: () async {
                    await diaLibreDeComida(diaElegido, comida)
                        .then((value) async {
                      if (value) {
                        await DatabaseProvider.db
                            .insertComidaDeHorario(comida.idComida, diaElegido,
                                listaComidasDelDia[i].idComidaDelDia)
                            .then((value) {
                          comidaNotifier.setComidaGuardada(true);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      } else {
                        Navigator.pop(context);
                        mostrarMensajeAlerta(context, diaStr);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${listaComidasDelDia[i].nombre}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: Colors.white)),
                        Container(width: 10),
                        Text("${listaComidasDelDia[i].hora}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            );
            listaBotones.add(Divider(height: 10, color: Colors.transparent));
          }
          return Column(
            children: listaBotones,
          );
        }
      },
    );
  }

  Future<bool> diaLibreDeComida(
      int diaElegido, Comida comidaSeleccionada) async {
    List<Comida> listaComidas;

    await DatabaseProvider.db.getComidasDeHorario(diaElegido).then(
      (lComidas) {
        listaComidas = lComidas;
      },
    );

    for (int i = 0; i < listaComidas.length; i++) {
      if (comidaSeleccionada.idComida == listaComidas[i].idComida) {
        return Future.value(false);
      }
      await Future.delayed(Duration.zero);
    }

    return Future.value(true);
  }

  mostrarMensajeAlerta(BuildContext context, String diaStr) {
    showDialog(
        context: context,
        builder: (dialogContex) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              margin: EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text("Comida en horario",
                      textScaleFactor: .9,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Container(
                    height: 30,
                  ),
                  Text("Esta comida ya está en el $diaStr actualmente.",
                      textScaleFactor: .65,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Container(
                    height: 30,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(dialogContex).pop();
                    },
                    child: Text(
                      "ACEPTAR",
                      textAlign: TextAlign.end,
                      textScaleFactor: .9,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(0xFF45AAB4),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
