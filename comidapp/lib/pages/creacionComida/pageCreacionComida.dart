import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/models/comidaCreada.dart';
import 'package:comidapp/pages/creacionComida/pageCincoPreparacion.dart';
import 'package:comidapp/pages/creacionComida/pageCuatroCantidades.dart';
import 'package:comidapp/pages/creacionComida/pageDosImagen.dart';
import 'package:comidapp/pages/creacionComida/pageTresIngredientes.dart';
import 'package:comidapp/pages/creacionComida/pageUnoInformacion.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CreacionComida extends StatefulWidget {
  CreacionComida({Key key}) : super(key: key);

  @override
  _CreacionComidaState createState() => _CreacionComidaState();
}

class _CreacionComidaState extends State<CreacionComida> {
  int _indicePagina = 0;
  PageController _pageController;

  ComidaCreada comidaCreada;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _indicePagina);
    comidaCreada = ComidaCreada.getComidaCreada();
    comidaCreada.limpiarElementos();
  }

  var _paginas = [
    PaginaUnoInformacion(),
    PaginaDosImagen(),
    PaginaTresIngredientes(),
    PaginaCuatroCantidades(),
    PaginaCincoPreparacion(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        heroTag: 'FloatingHero',
        backgroundColor: Theme.of(context).cardColor,
        onPressed: null,
        child: Text("${_indicePagina + 1} / ${_paginas.length}",
            textAlign: TextAlign.center,
            textScaleFactor: .9,
            style: Theme.of(context).textTheme.headline2),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        title: Text("Crear una comida",
            textAlign: TextAlign.center,
            textScaleFactor: 1.4,
            style: Theme.of(context).textTheme.headline5),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            bottomBNB(
                MdiIcons.chevronLeft, MdiIcons.chevronLeft, 0, "Anterior"),
            bottomBNB(
                MdiIcons.chevronRight, MdiIcons.chevronRight, 1, "Siguiente"),
          ],
        ),
      ),
      body: PageView(
        pageSnapping: true,
        controller: _pageController,
        children: _paginas,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (this.mounted) {
            setState(
              () {
                _indicePagina = index;
              },
            );
          }
        },
      ),
    );
  }

  bool camposDePaginaValidos() {
    print(comidaCreada.getCalorias());
    switch (_indicePagina) {
      case 0:
        if (comidaCreada.getNombreComida().length > 0 &&
            comidaCreada.getNombreComida().length <= 60 &&
            comidaCreada.getMinutosPreparacion() != null &&
            comidaCreada.getMinutosPreparacion().toString().length <= 4 &&
            comidaCreada.getCalorias() != null &&
            comidaCreada.getCalorias().toString().length <= 4 &&
            comidaCreada.getArea().length > 0 &&
            comidaCreada.getArea().length <= 25 &&
            comidaCreada.getCategoria().length > 0 &&
            comidaCreada.getCategoria().length <= 25) {
          return true;
        } else {
          return false;
        }
        break;
      case 1:
        if (comidaCreada.getRutaImagen().length > 0) {
          return true;
        } else {
          return false;
        }
        break;
      case 2:
        if (comidaCreada.getListaIngredientes().length > 0) {
          return true;
        } else {
          return false;
        }
        break;
      case 3:
        for (int i = 0;
            i < comidaCreada.getListaCantidadesIngredientes().length;
            i++) {
          if (comidaCreada.getListaCantidadesIngredientes()[i].length < 1) {
            return false;
          }
        }
        return true;
        break;
      case 4:
        if (comidaCreada.getPasosPreparacion().length > 0) {
          return true;
        } else {
          return false;
        }
        break;

      default:
        return true;
        break;
    }
  }

  mostrarMensajeTerminado(BuildContext context) {
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
                  Text("Comida guardada",
                      textScaleFactor: .9,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Container(
                    height: 30,
                  ),
                  Text("Se ha guardado correctamente tu comida.",
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

  Widget bottomBNB(
      IconData icono, IconData iconoSeleccionado, int index, String texto) {
    return Expanded(
      child: SizedBox(
        height: 46,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              if (camposDePaginaValidos() &&
                  _indicePagina == _paginas.length - 1) {
                Comida comida = new Comida(
                    nombreComida: comidaCreada.nombreComida,
                    categoria: comidaCreada.categoria,
                    area: comidaCreada.area,
                    minutosPreparacion: comidaCreada.minutosPreparacion,
                    pasosPreparacion: comidaCreada.pasosPreparacion,
                    calorias: comidaCreada.calorias,
                    rutaImagen: comidaCreada.rutaImagen,
                    favoritoComida: 0);

                DatabaseProvider.db.insertarNuevaComida(
                    comida,
                    comidaCreada.getListaIngredientes(),
                    comidaCreada.getListaCantidadesIngredientes());
                Navigator.pop(context);
                mostrarMensajeTerminado(context);
              }

              if (camposDePaginaValidos() || index == 0) {
                if (this.mounted) {
                  setState(() {
                    _indicePagina =
                        index == 0 ? _indicePagina - 1 : _indicePagina + 1;
                    _indicePagina < 0 ? _indicePagina = 0 : null;
                    _indicePagina > _paginas.length - 1
                        ? _indicePagina = _paginas.length - 1
                        : null;
                    _pageController.animateToPage(
                      _indicePagina,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 350),
                    );
                  });
                }
              } else {
                mostrarMensajeAlerta(context);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                index == 0
                    ? Container()
                    : Container(
                        child: Text(
                        _indicePagina == _paginas.length - 1
                            ? "Finalizar"
                            : "$texto",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2,
                      )),
                Icon(index == _indicePagina ? iconoSeleccionado : icono,
                    color: Theme.of(context).iconTheme.color, size: 22),
                index == 1
                    ? Container()
                    : Container(
                        child: Text(
                        "$texto",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  mostrarMensajeAlerta(BuildContext context) {
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
                  Text("No se puede continuar",
                      textScaleFactor: .9,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Container(
                    height: 30,
                  ),
                  Text(
                      "Asegúrate de completar correctamente lo solicitado en la ventana",
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
