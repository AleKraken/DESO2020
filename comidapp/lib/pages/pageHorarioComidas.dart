import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HorarioComidas extends StatefulWidget {
  HorarioComidas({Key key}) : super(key: key);

  @override
  _HorarioComidasState createState() => _HorarioComidasState();
}

class _HorarioComidasState extends State<HorarioComidas> {
  int _indicePagina = 0;
  var _diasSemana = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 35,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(MdiIcons.chevronLeft, color: Colors.black),
              Text("${_diasSemana[_indicePagina]}",
                  style: Theme.of(context).textTheme.headline1),
              Icon(MdiIcons.chevronRight, color: Colors.black),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFBB45C),
                Color(0xFFFE7A66),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: LoopPageView.builder(
            onPageChanged: (index) {
              _indicePagina = index;
              setState(() {});
            },
            itemCount: 7,
            itemBuilder: (_, index) {
              return paginaHorario(index);
            },
          ),
        ),
      ),
    );
  }

  Widget paginaHorario(int index) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            comidaDelDia("Desayuno", "9:00 am"),
            comidaDelDia("Almuerzo", "11:00 am"),
            comidaDelDia("Comida", "3:30 pm"),
            comidaDelDia("Cena", "8:30 pm"),
          ],
        ),
      ),
    );
  }

  Widget comidaDelDia(String nombreComidaDelDia, String horaComidaDelDia) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.transparent,
            height: 40,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 27),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("$nombreComidaDelDia",
                    style: Theme.of(context).textTheme.headline1),
                Container(width: 15),
                Text("$horaComidaDelDia",
                    style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: 10,
          ),
          tarjetaComida('assets/images/platoUno.png', "Ensalada con pollo",
              false, 5, 672),
          tarjetaComida(
              'assets/images/platoTres.png', "Sushi o algo así", true, 5, 720),
        ],
      ),
    );
  }

  Widget tarjetaComida(String rutaImagen, String nombreComida, bool favorito,
      int cantidadIngredientes, int cantidadCalorias) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 13,
            color: Colors.grey,
            offset: Offset(0, 4),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(rutaImagen),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$nombreComida",
                          style: Theme.of(context).textTheme.headline2),
                      Text("$cantidadIngredientes ingredientes",
                          style: Theme.of(context).textTheme.subtitle2),
                      Text("$cantidadCalorias calorías",
                          style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            child: favorito
                ? Icon(MdiIcons.heart, color: Colors.red)
                : Icon(MdiIcons.heartOutline, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
