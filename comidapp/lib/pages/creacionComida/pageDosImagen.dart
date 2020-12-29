import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:comidapp/models/comidaCreada.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PaginaDosImagen extends StatefulWidget {
  PaginaDosImagen({Key key}) : super(key: key);

  @override
  _PaginaDosImagenState createState() => _PaginaDosImagenState();
}

class _PaginaDosImagenState extends State<PaginaDosImagen> {
  final TextEditingController textControllerImagen =
      new TextEditingController();

  String rutaImagen;
  bool imagenValida = false;
  Widget imagen = new Container();
  ComidaCreada comidaCreada = ComidaCreada.getComidaCreada();

  @override
  void initState() {
    print(comidaCreada.getRutaImagen());
    rutaImagen = comidaCreada.getRutaImagen();
    textControllerImagen.text = rutaImagen;
    imagen = new Container(
      key: ValueKey(new Random().nextInt(5000)),
      width: 150,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: new Image.network(
        '$rutaImagen',
        key: ValueKey(rutaImagen),
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) {
            imagenValida = true;
            print(imagenValida);
            return child;
          }

          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          imagenValida = false;
          print(imagenValida);
          return new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Icon(MdiIcons.alertCircle, color: Color(0xFFFBB45C)),
              new Divider(color: Colors.transparent),
              new Text(
                "Aún no hay una imagen cargada",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          );
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 8),
              child: Text("Agrega la URL de la imagen",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline3),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
              child: Text(
                  "Ingresa una dirección válida y posteriormente selecciona 'Verificar'.",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            textField(textControllerImagen, context, "Dirección imagen",
                "Ejemplo: https: //imagenes.com/comidaImagen.jpg", false, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Theme.of(context).shadowColor,
                        offset: const Offset(0, 5),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  margin:
                      EdgeInsets.only(left: 20, right: 5, top: 0, bottom: 0),
                  child: FlatButton(
                      color: Theme.of(context).buttonColor,
                      padding: EdgeInsets.zero,
                      child: Text(
                        "Verificar",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(color: Colors.white),
                      ),
                      onPressed: () {
                        if (this.mounted) {
                          setState(() {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            rutaImagen = textControllerImagen.text;

                            imagen = new Container(
                              key: ValueKey(new Random().nextInt(5000)),
                              width: 150,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: new Image.network(
                                '$rutaImagen',
                                key: ValueKey(rutaImagen),
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    imagenValida = true;
                                    comidaCreada.setRutaImagen(rutaImagen);
                                    return child;
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  imagenValida = false;
                                  comidaCreada.setRutaImagen("");
                                  return new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      new Icon(MdiIcons.alert,
                                          color: Color(0xFFC63637)),
                                      new Divider(color: Colors.transparent),
                                      new Text(
                                        "No se pudo cargar la imagen. Intenta con otra dirección.",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          });
                        }
                      }),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 5, right: 20, top: 0, bottom: 0),
                      width: 150,
                      height: 120,
                      child: FadeIn(
                        duration: Duration(milliseconds: 500),
                        child: new ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imagen,
                        ),
                      ),
                    ),
                    Text(
                      imagenValida ? "Vista previa" : "",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController controlador, context,
      String textoLabel, String textoHint, bool esNumerico, int limiteCampo) {
    return Container(
      width: MediaQuery.of(context).size.width - 25,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      margin: EdgeInsets.only(bottom: 35),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 11,
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 5),
            spreadRadius: -2,
          ),
        ],
      ),
      child: TextField(
        keyboardType: esNumerico
            ? TextInputType.number
            : limiteCampo < 1
                ? TextInputType.url
                : TextInputType.text,
        controller: controlador,
        textAlign: TextAlign.left,
        textCapitalization: TextCapitalization.sentences,
        maxLines: 1,
        maxLength: limiteCampo < 1 ? null : limiteCampo,
        cursorColor: Theme.of(context).iconTheme.color,
        decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.subtitle1,
          icon: Icon(MdiIcons.web),
          hintText: "URL de imagen",
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
      ),
    );
  }
}
