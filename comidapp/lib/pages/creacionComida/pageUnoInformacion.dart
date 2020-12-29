import 'package:comidapp/models/comidaCreada.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PaginaUnoInformacion extends StatefulWidget {
  PaginaUnoInformacion({Key key}) : super(key: key);

  @override
  _PaginaUnoInformacionState createState() => _PaginaUnoInformacionState();
}

class _PaginaUnoInformacionState extends State<PaginaUnoInformacion> {
  ComidaCreada comidaCreada = ComidaCreada.getComidaCreada();
  final List<TextEditingController> listaControladores =
      new List<TextEditingController>();
  final List<FocusNode> listaFocus = new List<FocusNode>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      listaControladores.add(new TextEditingController());
      listaFocus.add(new FocusNode());
    }
    listaControladores[0].text = comidaCreada.nombreComida;
    listaControladores[3].text = comidaCreada.area;
    listaControladores[4].text = comidaCreada.categoria;
    listaControladores[1].text = comidaCreada.minutosPreparacion != null
        ? comidaCreada.minutosPreparacion.toString()
        : "";
    listaControladores[2].text =
        comidaCreada.calorias != null ? comidaCreada.calorias.toString() : "";
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
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          "¡Comienza llenando información sobre tu comida!",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline3),
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/platoComida.png'),
                        image: AssetImage('assets/images/platoComida.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              textField(listaControladores[0], 0, context, "Nombre",
                  "Nombre de tu comida", false, 60, MdiIcons.cardTextOutline),
              textField(
                  listaControladores[1],
                  1,
                  context,
                  "Tiempo preparación",
                  "Tiempo de preparación en minutos",
                  true,
                  4,
                  MdiIcons.clockTimeFiveOutline),
              textField(listaControladores[2], 2, context, "Calorías",
                  "Cantidad de calorías de tu comida", true, 4, MdiIcons.fire),
              textField(
                  listaControladores[3],
                  3,
                  context,
                  "Área",
                  "Ejemplos: Mexicana, Británica, Brasileña, etc.",
                  false,
                  25,
                  MdiIcons.earth),
              textField(
                  listaControladores[4],
                  4,
                  context,
                  "Tipo",
                  "Ejemplos: Mariscos, Vegetariana, Cerdo, etc.",
                  false,
                  25,
                  MdiIcons.foodDrumstick),
              Container(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(
      TextEditingController controlador,
      int index,
      context,
      String textoLabel,
      String textoHint,
      bool esNumerico,
      int limiteCampo,
      IconData icono) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Stack(
        children: [
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width - 25,
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
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
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.subtitle1,
                icon: Icon(icono),
                labelText: "$textoLabel",
                hintText: "$textoHint",
                border: InputBorder.none,
              ),
              inputFormatters: esNumerico
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ]
                  : null,
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
              focusNode: listaFocus[index],
              onSubmitted: (texto) {
                if (index < listaControladores.length - 1) {
                  FocusScope.of(context).requestFocus(listaFocus[index + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              onChanged: (texto) {
                int valorNuevo;
                switch (index) {
                  case 0:
                    comidaCreada.setNombreComida(texto);
                    break;
                  case 1:
                    valorNuevo = texto.length > 0 ? int.parse(texto) : null;
                    comidaCreada.setMinutosPreparacion(valorNuevo);
                    break;
                  case 2:
                    valorNuevo = texto.length > 0 ? int.parse(texto) : null;
                    comidaCreada.setCalorias(valorNuevo);
                    break;
                  case 3:
                    comidaCreada.setArea(texto);
                    break;
                  case 4:
                    comidaCreada.setCategoria(texto);
                    break;

                  default:
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
