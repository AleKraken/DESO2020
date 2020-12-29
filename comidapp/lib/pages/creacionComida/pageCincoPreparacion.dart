import 'package:comidapp/models/comidaCreada.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PaginaCincoPreparacion extends StatefulWidget {
  PaginaCincoPreparacion({Key key}) : super(key: key);

  @override
  _PaginaCincoPreparacionState createState() => _PaginaCincoPreparacionState();
}

class _PaginaCincoPreparacionState extends State<PaginaCincoPreparacion> {
  final TextEditingController controlador = new TextEditingController();
  final FocusNode focusNode = new FocusNode();

  ComidaCreada comidaCreada = ComidaCreada.getComidaCreada();

  @override
  void initState() {
    super.initState();
    controlador.text = comidaCreada.getPasosPreparacion();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                    "Para finalizar, escribe las instrucciones de preparación de tu comida",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline3),
              ),
              Container(
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
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: controlador,
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  cursorColor: Theme.of(context).iconTheme.color,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.subtitle1,
                    icon: Icon(MdiIcons.text),
                    labelText: "Instrucciones",
                    hintText: "Escribe las instrucciones de la preparación",
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 15),
                  focusNode: focusNode,
                  onChanged: (texto) {
                    comidaCreada.setPasosPreparacion(texto);
                  },
                ),
              ),
              Container(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
