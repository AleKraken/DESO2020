import 'package:animate_do/animate_do.dart';
import 'package:comidapp/models/comidaCreada.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PaginaCuatroCantidades extends StatefulWidget {
  PaginaCuatroCantidades({Key key}) : super(key: key);

  @override
  _PaginaCuatroCantidadesState createState() => _PaginaCuatroCantidadesState();
}

class _PaginaCuatroCantidadesState extends State<PaginaCuatroCantidades> {
  final List<TextEditingController> listaControladores =
      new List<TextEditingController>();
  final List<FocusNode> listaFocus = new List<FocusNode>();

  final ComidaCreada comidaCreada = ComidaCreada.getComidaCreada();

  @override
  void initState() {
    for (int i = 0; i < comidaCreada.listaIngredientes.length; i++) {
      listaControladores.add(new TextEditingController());
      listaFocus.add(new FocusNode());
      listaControladores.last.text =
          comidaCreada.getListaCantidadesIngredientes()[i];
    }
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
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text("Coloca las cantidades/medidas de cada ingrediente",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline3),
              ),
              Column(
                children: getRowsIngredientes(),
              ),
              Container(height: 50),
              Container(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getRowsIngredientes() {
    List<Widget> listaRows = new List<Widget>();

    for (int i = 0; i < comidaCreada.listaIngredientes.length; i++) {
      listaRows.add(rowIngrediente(listaControladores[i], i));
    }

    if (comidaCreada.listaIngredientes.length < 1) {
      listaRows.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          child: Text("No has agregado ningún ingrediente a tu comida",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1),
        ),
      );
    }

    return listaRows;
  }

  Widget rowIngrediente(TextEditingController controladorRow, int index) {
    return SlideInUp(
      delay: Duration(milliseconds: 100 + (index * 100)),
      from: 50,
      child: FadeIn(
        delay: Duration(milliseconds: 100 + (index * 100)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Theme.of(context).shadowColor,
                offset: const Offset(0, 5),
                spreadRadius: -2,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          "${comidaCreada.listaIngredientes[index].nombreIngrediente}",
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(fontSize: 12),
                        ),
                      ),
                      Container(width: 10),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              color: Colors.black,
                              offset: const Offset(0, 22),
                              spreadRadius: -14,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage(
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Container(
                                width: 30.0,
                                height: 30.0,
                                child: Image.asset(
                                    'assets/images/ingredienteCargando.png'),
                              );
                            },
                            placeholder: AssetImage(
                                'assets/images/ingredienteCargando.png'),
                            image: index > 534
                                ? AssetImage(
                                    'assets/images/ingredienteCargando.png')
                                : NetworkImage(
                                    '${comidaCreada.listaIngredientes[index].rutaImagenIngrediente}'),
                            fit: BoxFit.cover,
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: textField(controladorRow, context, index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(TextEditingController controlador, context, int index) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Container(
        height: 38,
        child: TextField(
          keyboardType: TextInputType.text,
          controller: controlador,
          textAlign: TextAlign.left,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 1,
          cursorColor: Theme.of(context).iconTheme.color,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.subtitle1,
            hintText: "Cantidad",
          ),
          style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
          focusNode: listaFocus[index],
          onSubmitted: (texto) {
            if (index < listaControladores.length - 1) {
              FocusScope.of(context).requestFocus(listaFocus[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          onChanged: (texto) {
            comidaCreada.setCantidadIngrediente(
                index, listaControladores[index].text);
          },
        ),
      ),
    );
  }
}
